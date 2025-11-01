//
//  RunStreakApp.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI
import BackgroundTasks

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
