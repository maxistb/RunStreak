//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

enum TimeRange: CaseIterable, Equatable {
  case days7, days30, days365, all

  var label: String {
    switch self {
    case .days7: return "7D"
    case .days30: return "30D"
    case .days365: return "1Y"
    case .all: return "All"
    }
  }

  var displayTitle: String {
    switch self {
    case .days7: return "Last 7 Days"
    case .days30: return "Last 30 Days"
    case .days365: return "Last Year"
    case .all: return "All Runs"
    }
  }

  var daysBack: Int? {
    switch self {
    case .days7: return 7
    case .days30: return 30
    case .days365: return 365
    case .all: return nil
    }
  }
}
