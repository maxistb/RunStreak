//
//  RunSummary.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Foundation

struct RunSummary {
  let totalDistanceKm: Double
  let avgPace: String
  let avgDistanceKm: Double
  let avgDurationMin: String
  let streakDays: Int
  let todayDistanceKm: Double
}

// MARK: - RunDay Collection Helpers

extension Array where Element == RunDay {
  func computeSummary() -> RunSummary {
    guard !isEmpty else {
      return RunSummary(
        totalDistanceKm: 0,
        avgPace: "--",
        avgDistanceKm: 0,
        avgDurationMin: "--",
        streakDays: 0,
        todayDistanceKm: 0
      )
    }

    let totalDistance = reduce(0) { $0 + $1.distanceInMeters } / 1000
    let totalDuration = reduce(0) { $0 + $1.durationInSeconds }
    let avgDistance = totalDistance / Double(count)
    let avgDuration = totalDuration / Double(count)

    let avgPaceSecondsPerKm = totalDuration / (totalDistance > 0 ? totalDistance : 1)
    let paceMinutes = Int(avgPaceSecondsPerKm / 60)
    let paceSeconds = Int(avgPaceSecondsPerKm.truncatingRemainder(dividingBy: 60))
    let avgPace = String(format: "%d:%02d /km", paceMinutes, paceSeconds)

    let calendar = Calendar.current
    let uniqueDays = Set(map { calendar.startOfDay(for: $0.date) }).sorted(by: >)

    // Calculate streak
    var streak = 0
    var dayCursor = calendar.startOfDay(for: Date())

    for day in uniqueDays {
      if calendar.isDate(day, inSameDayAs: dayCursor) {
        streak += 1
        dayCursor = calendar.date(byAdding: .day, value: -1, to: dayCursor)!
      } else {
        break
      }
    }

    // Calculate today’s distance
    let todayDistance = filter { calendar.isDateInToday($0.date) }
      .reduce(0) { $0 + $1.distanceInMeters } / 1000

    return RunSummary(
      totalDistanceKm: totalDistance,
      avgPace: avgPace,
      avgDistanceKm: avgDistance,
      avgDurationMin: String(format: "%.0f min", avgDuration / 60),
      streakDays: streak,
      todayDistanceKm: todayDistance
    )
  }
}
