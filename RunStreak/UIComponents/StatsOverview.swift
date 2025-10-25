//
//  StatsOverviewSoft.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 25.10.25.
//

import SwiftUI

struct StatsOverview: View {
  let runs: [RunDay]

  private var totalDistance: Double {
    runs.reduce(0) { $0 + $1.distanceInMeters } / 1000
  }

  private var avgPace: String {
    guard totalDistance > 0 else { return "-" }
    let pace = runs.reduce(0) { $0 + $1.paceMinPerKm } / Double(runs.count)
    let min = Int(pace)
    let sec = Int((pace - Double(min)) * 60)
    return "\(min):\(String(format: "%02d", sec))"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("This Week’s Summary")
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(AppColor.textPrimary)

      HStack(spacing: 12) {
        StatSoft(icon: "figure.run", label: "Distance", value: "\(String(format: "%.1f km", totalDistance))", color: AppColor.accentBlue)
        StatSoft(icon: "timer", label: "Avg Pace", value: "\(avgPace)/km", color: AppColor.accentPeach)
      }
    }
    .padding()
    .background(AppColor.card)
    .cornerRadius(24)
    .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
    .padding(.horizontal)
  }
}

struct StatSoft: View {
  let icon: String
  let label: String
  let value: String
  let color: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Image(systemName: icon)
        .font(.system(size: 18))
        .padding(10)
        .background(color.opacity(0.3))
        .clipShape(Circle())
      Text(label)
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(AppColor.textSecondary)
      Text(value)
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(AppColor.textPrimary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
