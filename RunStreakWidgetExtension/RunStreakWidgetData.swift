//
//  RunStreakWidgetData.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 13.10.25.
//

import Foundation
import WidgetKit

struct RunStreakWidgetData: Codable {
  let lastUpdated: Date
  let streakCount: Int
  let totalDistance: Double
  let averageVo2Max: Double
}
