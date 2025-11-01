//
//  HealthKitManager.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Foundation
import HealthKit
import WidgetKit

@MainActor
final class HealthKitManager {
  static let shared = HealthKitManager()
  private let healthStore = HKHealthStore()
  private var isMockEnabled: Bool = false

  private init() {}

  // MARK: - Authorization

  func requestAuthorization() async throws {
    guard HKHealthStore.isHealthDataAvailable() else { return }

    let typesToRead: Set = [
      HKObjectType.workoutType(),
      HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
      HKQuantityType.quantityType(forIdentifier: .heartRate)!,
      HKQuantityType.quantityType(forIdentifier: .vo2Max)!
    ]

    try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
  }

  // MARK: - Fetch Running Workouts

  func fetchVo2MaxSamples() async throws -> [Date: Double] {
    let vo2Type = HKQuantityType.quantityType(forIdentifier: .vo2Max)!
    let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: [])
    return try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: vo2Type,
        predicate: predicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: nil
      ) { _, samples, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        guard let quantitySamples = samples as? [HKQuantitySample] else {
          continuation.resume(returning: [:])
          return
        }
        var vo2ByDate: [Date: Double] = [:]
        for sample in quantitySamples {
          let value = sample.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
          let date = Calendar.current.startOfDay(for: sample.startDate)
          vo2ByDate[date] = value
        }
        continuation.resume(returning: vo2ByDate)
      }
      healthStore.execute(query)
    }
  }

  func fetchAverageHeartRate(for workout: HKWorkout) async throws -> Double? {
    let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
    let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
    return try await withCheckedThrowingContinuation { continuation in
      let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, statistics, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        guard let avgQuantity = statistics?.averageQuantity() else {
          continuation.resume(returning: nil)
          return
        }
        let avgBpm = avgQuantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
        continuation.resume(returning: avgBpm)
      }
      healthStore.execute(query)
    }
  }

  func fetchRunningWorkouts() async throws -> [RunDay] {
    #if targetEnvironment(simulator)
    return try await mockFetchRunningWorkouts()
    #endif

    return try await fetchHealthKitWorkouts()
  }

  func fetchHealthKitWorkouts() async throws -> [RunDay] {
    let predicate = HKQuery.predicateForSamples(
      withStart: nil,
      end: nil,
      options: [.strictStartDate]
    )
    let workoutType = HKObjectType.workoutType()
    // Fetch running workouts
    let workouts: [HKWorkout] = try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: workoutType,
        predicate: predicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: nil
      ) { _, samples, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        guard let workouts = samples as? [HKWorkout] else {
          continuation.resume(returning: [])
          return
        }
        let runningWorkouts = workouts.filter {
          $0.workoutActivityType == .running
        }
        continuation.resume(returning: runningWorkouts)
      }
      healthStore.execute(query)
    }

    // Fetch VO2Max samples
    let vo2MaxByDate = try await fetchVo2MaxSamples()

    // For each workout, fetch avg heart rate and build RunDay
    var runDays: [RunDay] = []
    for workout in workouts {
      let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
      let calories = 100.0
      let source = workout.sourceRevision.source.name
      let avgHeartRate = try? await fetchAverageHeartRate(for: workout)
      let vo2Date = Calendar.current.startOfDay(for: workout.startDate)
      let vo2Max = vo2MaxByDate[vo2Date]
      let runDay = RunDay(
        uuid: workout.uuid,
        date: workout.startDate,
        distanceInMeters: distance,
        durationInSeconds: workout.duration,
        calories: calories,
        source: source,
        avgHeartRate: avgHeartRate,
        vo2Max: vo2Max
      )
      runDays.append(runDay)
    }
    print("📦 Retrieved \(runDays.count) running workouts")
    return runDays
  }

  func startWorkoutObserver() {
    let type = HKObjectType.workoutType()
    let query = HKObserverQuery(sampleType: type, predicate: nil) { _, _, _ in
      Task {
        let runs = try? await self.fetchRunningWorkouts()
        let streak = await self.calculateStreak(from: runs ?? [])
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: .now))!

        let thisWeekRuns = runs?.filter { $0.date >= startOfWeek } ?? []

        let totalDistanceKm = thisWeekRuns.reduce(0) { $0 + $1.distanceInMeters } / 1000
        let maxVo2Max = thisWeekRuns.compactMap(\.vo2Max).max() ?? 0

        await self.saveWidgetData(streak: streak, distance: totalDistanceKm, vo2Max: maxVo2Max)
      }
    }
    healthStore.execute(query)
    healthStore.enableBackgroundDelivery(for: type, frequency: .immediate, withCompletion: { _, _ in })
  }

  private func calculateStreak(from runs: [RunDay]) -> Int {
    let sortedDays = Array(Set(runs.map { Calendar.current.startOfDay(for: $0.date) })).sorted(by: >)
    guard let mostRecent = sortedDays.first else { return 0 }

    var streak = 1
    var previousDay = mostRecent
    for day in sortedDays.dropFirst() {
      let daysBetween = Calendar.current.dateComponents([.day], from: day, to: previousDay).day ?? 0
      if daysBetween == 1 {
        streak += 1
        previousDay = day
      } else { break }
    }
    return streak
  }
}

private let appGroupID = "group.com.runstreak.app"

extension HealthKitManager {
  func saveWidgetData(streak: Int, distance: Double, vo2Max: Double) async {
    let widgetData = RunStreakWidgetData(
      lastUpdated: .now,
      streakCount: streak,
      totalDistance: distance,
      averageVo2Max: vo2Max
    )
    let url = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: "group.com.runstreak.app")!
      .appendingPathComponent("streak.json")
    if let data = try? JSONEncoder().encode(widgetData) {
      try? data.write(to: url)
    }
    WidgetCenter.shared.reloadAllTimelines()
  }

  func refreshAndSaveWidgetData() async {
    do {
      let runs = try await fetchRunningWorkouts()
      let streak = calculateStreak(from: runs)

      let calendar = Calendar.current
      let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: .now))!

      let thisWeekRuns = runs.filter { $0.date >= startOfWeek }

      let totalDistanceKm = thisWeekRuns.reduce(0) { $0 + $1.distanceInMeters } / 1000
      let maxVo2Max = thisWeekRuns.compactMap(\.vo2Max).max() ?? 0

      await saveWidgetData(
        streak: streak,
        distance: totalDistanceKm,
        vo2Max: maxVo2Max
      )

      WidgetCenter.shared.reloadAllTimelines()
    } catch {
      print("Background fetch failed:", error)
    }
  }
}

// MARK: - Mock Mode for Simulator

extension HealthKitManager {
  /// Returns simulated running workouts for previews or simulator use
  func mockFetchRunningWorkouts() async throws -> [RunDay] {
    print("🧪 Running in simulator — returning mock running data")

    let now = Date()
    let calendar = Calendar.current

    // 10 consecutive days of mock runs
    let mockRuns: [RunDay] = (0..<31).map { i in
      let randomDistance = Double.random(in: 4.5...8.0) * 1000 // meters
      let randomDuration = randomDistance / Double.random(in: 2.5...3.0) * 60 // seconds
      let randomHR = Double.random(in: 135...165)
      let vo2Base = 52.0 - (Double(i) * Double.random(in: 0...0.4)) // gradual increase to simulate improvement
      let vo2Max = min(vo2Base, 62.9)

      return RunDay(
        uuid: UUID(),
        date: calendar.date(byAdding: .day, value: -i, to: now)!,
        distanceInMeters: randomDistance,
        durationInSeconds: randomDuration,
        calories: Double.random(in: 250...600),
        source: "Mock Run",
        avgHeartRate: randomHR,
        vo2Max: vo2Max
      )
    }

    return mockRuns.sorted(by: { $0.date < $1.date })
  }

  func mockFetchVo2MaxSamples() async throws -> [Date: Double] {
    let calendar = Calendar.current
    let now = Date()

    var mockSamples: [Date: Double] = [:]
    for i in 0..<10 {
      let date = calendar.date(byAdding: .day, value: -i, to: now)!
      mockSamples[calendar.startOfDay(for: date)] = Double.random(in: 45...63)
    }
    return mockSamples
  }
}
