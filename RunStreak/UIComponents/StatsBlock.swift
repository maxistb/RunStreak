
//
//  StatsCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct StatsBlock: View {
  let totalDistance: Double
  let averagePace: Double
  let runs: [RunDay]

  private func averageDistance() -> String {
    guard !runs.isEmpty else { return "0.0" }
    let avg = runs.reduce(0) { $0 + $1.distanceInMeters / 1000 } / Double(runs.count)
    return String(format: "%.1f", avg)
  }

  private func averageDuration() -> String {
    guard !runs.isEmpty else { return "0" }
    let avg = runs.reduce(0) { $0 + $1.durationInSeconds } / Double(runs.count)
    return String(format: "%.0f", avg / 60)
  }

  private func formatPace(_ pace: Double) -> String {
    let min = Int(pace)
    let sec = Int((pace - Double(min)) * 60)
    return String(format: "%d:%02d /km", min, sec)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Stats")
        .font(.system(size: 18, weight: .heavy))
        .foregroundColor(.white)

      HStack(spacing: 16) {
        StatBlockItem(title: "Total", value: "\(String(format: "%.1f km", totalDistance))")
        StatBlockItem(title: "Pace", value: formatPace(averagePace))
        StatBlockItem(title: "Avg", value: "\(averageDistance()) km")
      }
    }
    .padding()
    .background(AppColor.surface)
    .cornerRadius(12)
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
    .shadow(color: AppColor.primary.opacity(0.6), radius: 0, x: 5, y: 5)
  }
}

struct StatBlockItem: View {
  let title: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title.uppercased())
        .font(.system(size: 11, weight: .bold))
        .foregroundColor(.white.opacity(0.7))
      Text(value)
        .font(.system(size: 15, weight: .heavy))
        .foregroundColor(.white)
    }
    .padding(8)
    .background(AppColor.background)
    .cornerRadius(6)
    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 2))
  }
}
