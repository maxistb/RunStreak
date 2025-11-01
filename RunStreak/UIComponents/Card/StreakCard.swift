//
//  StreakCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct StreakCard: View {
  @AppStorage("highestStreak") private var highestStreak: Int = 0
  let streakCount: Int

  private var isNewRecord: Bool {
    streakCount >= highestStreak
  }

  private var motivationText: String {
    switch streakCount {
    case 0:
      return "Let’s get back on track — every step counts 💪"
    case 1:
      return "Every streak starts with one run. Keep it going! 🏁"
    case 2...6:
      return "Great start! Keep the momentum rolling 🔥"
    case 7...13:
      return "A full week! You’re building strong habits 💥"
    case 14...29:
      return "Two weeks strong — you’re unstoppable 💪"
    case 30...:
      return "Legendary consistency. You’re built different 🌟"
    default:
      return "Keep moving forward!"
    }
  }

  var body: some View {
    Button {} label: {
      VStack(spacing: 20) {
        if isNewRecord {
          BrutalistBadge(text: "NEW RECORD", color: .yellow)
        }

        Image(.starPink)
          .resizable()
          .scaledToFit()
          .frame(height: 120)

        VStack(spacing: 6) {
          Text("\(streakCount) DAY\(streakCount == 1 ? "" : "S")")
            .font(.system(size: 28, weight: .heavy, design: .rounded))
            .foregroundColor(.black)

          Text(motivationText)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.black.opacity(0.7))
            .padding(.horizontal, 30)
            .multilineTextAlignment(.center)
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
    .onAppear {
      if streakCount > highestStreak {
        highestStreak = streakCount
      }
    }
  }
}
