//
//  MeasurementSystem+Extension.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 31.10.25.
//

import Foundation

public extension Locale.MeasurementSystem {
  /// Converts meters to the appropriate distance unit (km or miles)
  func convertDistance(_ km: Double) -> Double {
    switch self {
    case .metric:
      return km
    default:
      return km / 1.60934 // miles
    }
  }

  /// Returns the appropriate unit symbol (km or mi)
  var distanceUnitSymbol: String {
    switch self {
    case .metric:
      return "km"
    default:
      return "mi"
    }
  }

  /// Returns the appropriate pace unit (min/km or min/mi)
  var paceUnitSymbol: String {
    switch self {
    case .metric:
      return "min/km"
    default:
      return "min/mi"
    }
  }
}
