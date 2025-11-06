//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import BackgroundTasks
import SwiftUI

@main
struct RunStreakApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      HomeScreen()
        .preferredColorScheme(.light)
    }
  }
}
