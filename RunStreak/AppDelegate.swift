//
//  AppDelegate.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 01.11.25.
//

import BackgroundTasks
import UIKit
import WidgetKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerBackgroundTasks()
    HealthKitManager.shared.startWorkoutObserver()
    return true
  }

  private func registerBackgroundTasks() {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.runstreak.refresh", using: nil) { task in
      self.handleBackgroundRefresh(task: task as! BGProcessingTask)
    }
  }

  private func handleBackgroundRefresh(task: BGProcessingTask) {
    scheduleNextBackgroundRefresh()

    Task {
      await HealthKitManager.shared.refreshAndSaveWidgetData()
      WidgetCenter.shared.reloadAllTimelines()
      task.setTaskCompleted(success: true)
    }
  }

  func scheduleNextBackgroundRefresh() {
    let request = BGProcessingTaskRequest(identifier: "com.runstreak.refresh")
    request.requiresNetworkConnectivity = false
    request.requiresExternalPower = false
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("Could not schedule background refresh:", error)
    }
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    scheduleNextBackgroundRefresh()
  }
}
