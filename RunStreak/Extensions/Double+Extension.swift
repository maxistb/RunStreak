//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Foundation

public extension Double {
  /// Returns a localized distance string (e.g., “12.5 km”, “7.8 mi”, “7.8 miles (UK)”)
  func toLocaleDistanceString(locale: Locale = .current) -> String {
    let measurementSystem = locale.measurementSystem

    let targetUnit: UnitLength = {
      switch measurementSystem {
        case .metric:
          return .kilometers
        default:
          return .miles
      }
    }()

    let measurement = Measurement(value: self, unit: UnitLength.kilometers).converted(to: targetUnit)
    let formatted = measurement.formatted(
      .measurement(width: .narrow, usage: .road)
        .locale(locale)
    )

    return formatted
  }
}
