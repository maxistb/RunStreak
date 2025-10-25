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
    let query = HKObserverQuery(sampleType: type, predicate: nil) { _, _, error in
      if let error = error {
        print("Observer error:", error)
        return
      }
      Task {
        // Refetch workouts and update widget data
        let runs = try? await self.fetchRunningWorkouts()
        let streak = await self.calculateStreak(from: runs ?? [])
        await self.saveStreakToAppGroup(streak: streak)
        WidgetCenter.shared.reloadAllTimelines()
      }
    }
    healthStore.execute(query)
    healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { success, error in
      print("Background delivery:", success, error?.localizedDescription ?? "")
    }
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
  func saveStreakToAppGroup(streak: Int) {
    let data = RunStreakWidgetData(streakCount: streak, lastUpdated: Date())
    if let encoded = try? JSONEncoder().encode(data) {
      let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!.appendingPathComponent("streak.json")
      try? encoded.write(to: url)
    }
  }

  func readStreakFromAppGroup() -> RunStreakWidgetData? {
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!.appendingPathComponent("streak.json")
    guard let data = try? Data(contentsOf: url) else { return nil }
    return try? JSONDecoder().decode(RunStreakWidgetData.self, from: data)
  }
}
