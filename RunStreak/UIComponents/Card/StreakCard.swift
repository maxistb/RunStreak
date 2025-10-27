//
//  StreakCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct StreakCard: View {
  let streakCount: Int

  var body: some View {
    Button {} label: {
      VStack(spacing: 20) {
        Image(.starPink)
          .resizable()
          .scaledToFit()
          .frame(height: 120)

        VStack(spacing: 6) {
          Text("\(streakCount) DAY\(streakCount == 1 ? "" : "S")")
            .font(.system(size: 28, weight: .heavy, design: .rounded))
            .foregroundColor(.black)

          Text("You’re on a roll! Keep moving 🌟")
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.black.opacity(0.7))
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 20)
    }
    .buttonStyle(
      NeobrutalistButtonStyle(
        cornerRadius: 20,
        shadowOffset: 4,
        borderColor: .black,
        backgroundColor: AppColor.accentPurple
      )
    )
  }
}
