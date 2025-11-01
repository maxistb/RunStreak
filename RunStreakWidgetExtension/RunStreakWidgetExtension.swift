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
  let distance: Double
  let vo2Max: Double
}

struct RunStreakProvider: TimelineProvider {
  private let appGroupID = "group.com.runstreak.app"

  func placeholder(in context: Context) -> RunStreakEntry {
    RunStreakEntry(date: .now, streak: 31, distance: 13, vo2Max: 60)
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
      return RunStreakEntry(
        date: widgetData.lastUpdated,
        streak: widgetData.streakCount,
        distance: widgetData.totalDistance,
        vo2Max: widgetData.averageVo2Max
      )
    } else {
      return RunStreakEntry(date: Date(), streak: 0, distance: 0, vo2Max: 0)
    }
  }
}

struct RunStreakWidgetView: View {
  @Environment(\.widgetRenderingMode) private var renderingMode
  @Environment(\.colorScheme) private var colorScheme
  @Environment(\.widgetFamily) private var widgetRender

  var entry: RunStreakEntry

  var body: some View {
    switch widgetRender {
      case .systemSmall:
        smallContent
      default:
        defaultContent
    }
  }

  private var smallContent: some View {
    Group {
      if renderingMode == .fullColor {
        metricBlock(icon: "flame.fill", value: "\(entry.streak)", label: "STREAK", color: AppColor.accentPeach)
          .containerBackground(for: .widget) { Color(uiColor: .secondarySystemGroupedBackground) }
      } else {
        tintedMetric(icon: "flame.fill", value: "\(entry.streak)", label: "STREAK")
          .luminanceToAlpha()
          .widgetAccentable()
          .containerBackground(for: .widget) { Color.clear }
      }
    }

    .containerBackground(for: .widget) {
      renderingMode == .fullColor ? Color(uiColor: .secondarySystemGroupedBackground) : Color.clear
    }
  }

  private var defaultContent: some View {
    VStack(spacing: 12) {
      Text("THIS WEEK")
        .font(.system(size: 12, weight: .heavy))
        .foregroundColor(.secondary.opacity(0.7))
        .multilineTextAlignment(.center)

      switch renderingMode {
        case .fullColor:
          whoopStyleBrutalist
            .containerBackground(for: .widget) { Color(uiColor: .secondarySystemGroupedBackground) }

        default:
          whoopStyleTinted
            .containerBackground(for: .widget) { Color.clear }
            .widgetAccentable()
      }
    }
  }

  private var whoopStyleBrutalist: some View {
    HStack(spacing: 0) {
      metricBlock(
        icon: "flame.fill",
        value: "\(entry.streak)",
        label: "STREAK",
        color: AppColor.accentPeach
      )
      Divider().frame(height: 60).background(Color.black)
      metricBlock(
        icon: "figure.run",
        value: String(format: "%.1f", entry.distance),
        label: "DISTANCE",
        color: AppColor.accentBlue
      )
      Divider().frame(height: 60).background(Color.black)
      metricBlock(
        icon: "lungs.fill",
        value: String(format: "%.1f", entry.vo2Max),
        label: "VO₂MAX",
        color: AppColor.accentMint
      )
    }
    .padding()
  }

  private func metricBlock(icon: String, value: String, label: String, color: Color) -> some View {
    VStack(spacing: 4) {
      Image(systemName: icon)
        .font(.system(size: 22, weight: .bold))
        .foregroundColor(.black)
        .padding(6)
        .background(color)
        .clipShape(Circle())
        .overlay(Circle().stroke(.black, lineWidth: 2))

      Text(value)
        .font(.system(size: 22, weight: .bold, design: .rounded))

      Text(label)
        .font(.system(size: 12, weight: .heavy))
        .foregroundColor(.secondary.opacity(0.7))
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .foregroundStyle(.primary)
  }

  private var whoopStyleTinted: some View {
    HStack(spacing: 0) {
      tintedMetric(icon: "flame.fill", value: "\(entry.streak)", label: "STREAK")
      Divider().frame(height: 50).background(.primary)
      tintedMetric(icon: "figure.run", value: String(format: "%.1f", entry.distance), label: "DISTANCE")
      Divider().frame(height: 50).background(.primary)
      tintedMetric(icon: "lungs.fill", value: String(format: "%.1f", entry.vo2Max), label: "VO₂MAX")
    }
    .padding()
    .luminanceToAlpha()
  }

  private func tintedMetric(icon: String, value: String, label: String) -> some View {
    VStack(spacing: 4) {
      Image(systemName: icon)
        .font(.system(size: 20, weight: .medium))
      Text(value)
        .font(.system(size: 22, weight: .bold, design: .rounded))
      Text(label)
        .font(.system(size: 11, weight: .semibold))
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
  }
}
