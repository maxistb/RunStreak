//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Foundation
import WidgetKit

struct RunStreakWidgetData: Codable {
  let lastUpdated: Date
  let streakCount: Int
  let totalDistance: Double
  let averageVo2Max: Double
}
