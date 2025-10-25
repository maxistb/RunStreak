//
//  TodayRunCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct TodayRunCard: View {
  let distanceKm: Double

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Today's Run Complete ✅")
        .font(.system(size: 18, weight: .semibold, design: .rounded))
        .foregroundColor(AppColor.textPrimary)

      Text("+\(String(format: "%.1f", distanceKm)) km added to your streak")
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(AppColor.textSecondary)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(AppColor.accentMint)
    .cornerRadius(20)
    .shadow(color: AppColor.accentMint.opacity(0.5), radius: 10, y: 4)
    .padding(.horizontal)
  }
}
