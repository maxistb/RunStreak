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
    VStack(spacing: 10) {
      // Brutalist badge (for record streaks, optional)
      Text("NEW RECORD")
        .font(.system(size: 12, weight: .heavy))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.yellow)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
        .cornerRadius(8)
        .shadow(color: .black, radius: 0, x: 3, y: 3)

      // Main streak number
      Text("\(entry.streak)")
        .font(.system(size: 56, weight: .black, design: .rounded))
        .foregroundColor(.black)
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 2))
        .cornerRadius(16)
        .shadow(color: .black, radius: 0, x: 4, y: 4)

      // Label
      Text(entry.streak == 1 ? "DAY STREAK" : "DAYS STREAK")
        .font(.system(size: 14, weight: .bold))
        .foregroundColor(.black)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppColor.accentMint)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
        .cornerRadius(8)
        .shadow(color: .black, radius: 0, x: 3, y: 3)

      // Optional motivational line
      if entry.streak > 0 {
        Text(motivationText(for: entry.streak))
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.black.opacity(0.8))
          .multilineTextAlignment(.center)
          .padding(.top, 4)
          .padding(.horizontal, 6)
      }
    }
    .padding()
    .containerBackground(Color(uiColor: .secondarySystemGroupedBackground), for: .widget)
  }

  private func motivationText(for streak: Int) -> String {
    switch streak {
    case 0:
      return "Start your next run today!"
    case 1:
      return "Every streak starts with one run 🏁"
    case 2...6:
      return "Great pace! Keep the streak alive 🔥"
    case 7...13:
      return "A full week! You’re building habits 💪"
    case 14...29:
      return "Two weeks strong — unstoppable 💥"
    case 30...:
      return "Legendary consistency 🌟"
    default:
      return "Keep running strong!"
    }
  }
}
