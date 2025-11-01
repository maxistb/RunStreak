//
//  String+Extension.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 31.10.25.
//

import Foundation

public extension String {
  var measurentIdentifier: Self {
    switch Locale.current.measurementSystem {
      case .metric: "km"
      default: "miles"
    }
  }
}
