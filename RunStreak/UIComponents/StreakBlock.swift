//
//  StreakCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct StreakBlock: View {
  let streakCount: Int

  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: "flame.fill")
        .foregroundColor(.orange)
        .font(.system(size: 40))
        .padding(16)
        .background(AppColor.accentPeach)
        .clipShape(Circle())

      VStack(alignment: .leading, spacing: 4) {
        Text("\(streakCount) Day\(streakCount > 1 ? "s" : "")")
          .font(.system(size: 28, weight: .bold, design: .rounded))
          .foregroundColor(AppColor.textPrimary)
        Text("You’re on a roll! Keep moving 🌟")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(AppColor.textSecondary)
      }
      Spacer()
    }
    .padding()
    .background(AppColor.card)
    .cornerRadius(24)
    .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
    .padding(.horizontal)
  }
}
