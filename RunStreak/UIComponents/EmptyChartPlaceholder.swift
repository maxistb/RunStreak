//
//  EmptyChartPlaceholder.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//


import SwiftUI

struct EmptyChartPlaceholder: View {
  var body: some View {
    VStack(spacing: 6) {
      Image(systemName: "chart.line.uptrend.xyaxis")
        .font(.system(size: 26))
        .foregroundColor(.white.opacity(0.25))
      Text("No data for the last 30 days")
        .font(.system(size: 13))
        .foregroundColor(.white.opacity(0.4))
    }
    .frame(height: 120)
    .frame(maxWidth: .infinity)
  }
}