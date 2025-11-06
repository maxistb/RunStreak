//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
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
    self.date = date
    self.distanceInMeters = distanceInMeters
    self.durationInSeconds = durationInSeconds
    self.calories = calories
    self.source = source
    self.avgHeartRate = avgHeartRate
    self.vo2Max = vo2Max
  }
}
