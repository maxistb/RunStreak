//
//  RunStreakWidgetExtension.swift
//  RunStreakWidgetExtension
//
//  Created by Maximillian Stabe on 13.10.25.
//

import SwiftUI
import WidgetKit

struct RunStreakEntry: TimelineEntry {
  let date: Date
  let streak: Int
}

struct RunStreakProvider: TimelineProvider {
  private let appGroupID = "group.com.runstreak.app"

  func placeholder(in context: Context) -> RunStreakEntry {
    RunStreakEntry(date: Date(), streak: 3)
  }

  func getSnapshot(in context: Context, completion: @escaping (RunStreakEntry) -> Void) {
    completion(loadEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<RunStreakEntry>) -> Void) {
    let entry = loadEntry()
    let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
    completion(timeline)
  }

  private func loadEntry() -> RunStreakEntry {
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!.appendingPathComponent("streak.json")
    if let data = try? Data(contentsOf: url),
       let widgetData = try? JSONDecoder().decode(RunStreakWidgetData.self, from: data)
    {
      return RunStreakEntry(date: widgetData.lastUpdated, streak: widgetData.streakCount)
    } else {
      return RunStreakEntry(date: Date(), streak: 0)
    }
  }
}

struct RunStreakWidgetView: View {
  var entry: RunStreakEntry

  var body: some View {
    VStack(spacing: 8) {
      Text("🔥")
        .font(.system(size: 48))
      Text("\(entry.streak)")
        .font(.system(size: 52, weight: .heavy, design: .rounded))
        .foregroundColor(.white)
        .shadow(color: .purple.opacity(0.7), radius: 0, x: 4, y: 4)
      Text(entry.streak == 1 ? "DAY STREAK" : "DAYS STREAK")
        .font(.system(size: 13, weight: .semibold))
        .foregroundColor(.white.opacity(0.8))
    }
    .containerBackground(Color(uiColor: .secondarySystemGroupedBackground), for: .widget)
  }
}
