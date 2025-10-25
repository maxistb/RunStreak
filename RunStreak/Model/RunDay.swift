//
//  RunDay.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Foundation

struct RunDay {
  var uuid: UUID = .init()
  var date = Date.now
  var distanceInMeters: Double = 0
  var durationInSeconds: Double = 0
  var calories: Double?
  var source: String?
  var avgHeartRate: Double?
  var vo2Max: Double?

  init(
    uuid: UUID = UUID(),
    date: Date = .now,
    distanceInMeters: Double = 0,
    durationInSeconds: Double = 0,
    calories: Double? = nil,
    source: String? = nil,
    avgHeartRate: Double? = nil,
    vo2Max: Double? = nil
  ) {
    self.uuid = uuid
    self.date = Calendar.current.startOfDay(for: date)
    self.distanceInMeters = distanceInMeters
    self.durationInSeconds = durationInSeconds
    self.calories = calories
    self.source = source
    self.avgHeartRate = avgHeartRate
    self.vo2Max = vo2Max
  }

  var paceMinPerKm: Double {
    let distanceKm = distanceInMeters / 1000
    guard distanceKm > 0 else { return 0 }
    return durationInSeconds / 60 / distanceKm
  }

  var formattedPace: String {
    let pace = paceMinPerKm
    let minutes = Int(pace)
    let seconds = Int((pace - Double(minutes)) * 60)
    return String(format: "%d:%02d min/km", minutes, seconds)
  }
}
