//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
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
