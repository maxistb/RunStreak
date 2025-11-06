//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Foundation
import SwiftUI

@Observable
final class HomeScreenVM {
  private let healthKit = HealthKitManager.shared
  private(set) var runs: [RunDay] = []
  private(set) var isLoading = false

  var groupedDistance: [ChartDistanceModel] {
    groupRunsByDay(runs, valueKey: { $0.distanceInMeters })
      .map { .init(date: $0.date, value: $0.average / 1000) }
  }

  var groupedHeartRate: [ChartHeartRateModel] {
    groupRunsByDay(runs, valueKey: { $0.avgHeartRate })
      .map { .init(date: $0.date, value: $0.average) }
  }

  var groupedVo2Max: [ChartVo2MaxModel] {
    groupRunsByDay(runs, valueKey: { $0.vo2Max })
      .map { .init(date: $0.date, value: $0.average) }
  }

  var streakCount: Int {
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

  var todayDistanceString: String {
    let meters = runs
      .filter { Calendar.current.isDateInToday($0.date) }
      .reduce(0.0) { $0 + $1.distanceInMeters }
    return (meters / 1000.0).toLocaleDistanceString()
  }

  var hasCompletedTodayRun: Bool {
    runs
      .filter { Calendar.current.isDateInToday($0.date) }
      .reduce(0.0) { $0 + $1.distanceInMeters } > 0
  }

  func totalDistanceLast7Days(locale: Locale) -> String {
    metricAverage(days: 7) { $0.distanceInMeters / 1000 }.toLocaleDistanceString()
  }

  var avgHeartRateLast7Days: Double {
    metricAverage(days: 7) { $0.avgHeartRate }
  }

  var avgVo2MaxLast7Days: Double {
    metricAverage(days: 7) { $0.vo2Max }
  }

  func loadRuns() async {
    guard !isLoading else { return }
    isLoading = true
    defer { isLoading = false }

    do {
      try await healthKit.requestAuthorization()
      runs = try await healthKit.fetchRunningWorkouts()
    } catch {
      print("⚠️ Failed to fetch runs:", error.localizedDescription)
    }
  }

  private func metricAverage(days: Int, key: (RunDay) -> Double?) -> Double {
    let start = Calendar.current.date(byAdding: .day, value: -days, to: .now)!
    let filtered = runs.filter { $0.date >= start }
    let valid = filtered.compactMap(key).filter { $0 > 0 }
    guard !valid.isEmpty else { return 0 }
    return valid.reduce(0, +) / Double(valid.count)
  }

  func groupRunsByDay(
    _ runs: [RunDay],
    valueKey: (RunDay) -> Double?
  ) -> [(date: Date, average: Double)] {
    let calendar = Calendar.current
    let grouped = Dictionary(grouping: runs, by: { calendar.startOfDay(for: $0.date) })
    return grouped.compactMap { date, items in
      let valid = items.compactMap(valueKey).filter { $0.isFinite && $0 > 0 }
      guard !valid.isEmpty else { return nil }
      let avg = valid.reduce(0, +) / Double(valid.count)
      return avg.isFinite ? (date, avg) : nil
    }
    .sorted { $0.date < $1.date }
  }
}
