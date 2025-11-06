//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import SwiftUI
import WidgetKit

@main
struct RunStreakWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "RunStreakWidget", provider: RunStreakProvider()) { entry in
      RunStreakWidgetView(entry: entry)
    }
    .supportedFamilies([.systemSmall, .systemMedium])
    .configurationDisplayName("Run Streak")
    .description("Shows your current running streak.")
  }
}
