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
    HStack(spacing: 24) {
      Spacer()

      VStack(spacing: 8) {
        Text("🏃‍♂️")
          .font(.system(size: 32))
        Text("Distance")
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundColor(.white)
        Text("\(String(format: "%.1f km", totalDistance))")
          .font(.system(size: 18, weight: .bold, design: .rounded))
          .foregroundColor(.white)
      }

      Spacer()

      VStack(spacing: 8) {
        Text("⏱")
          .font(.system(size: 32))
        Text("Pace")
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundColor(.white)
        Text("\(avgPace) min/km")
          .font(.system(size: 18, weight: .bold, design: .rounded))
          .foregroundColor(.white)
      }

      Spacer()
    }
    .padding()
    .background {
      Image(.backgroundHorizontal)
        .resizable()
        .scaledToFill()
        .overlay {
          Color.black.opacity(0.4)
        }
    }
    .clipShape(
      RoundedRectangle(cornerRadius: 20)
    )
  }
}
