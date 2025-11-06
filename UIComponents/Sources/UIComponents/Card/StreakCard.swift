//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct StreakCard: View {
  @AppStorage("highestStreak") private var highestStreak: Int = 0
  private let streakCount: Int

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

  public init(streakCount: Int) {
    self.streakCount = streakCount
  }

  public var body: some View {
    VStack(spacing: Spacing.m) {
      if isNewRecord {
        BrutalistBadge(text: "NEW RECORD", color: .yellow)
      }

      Image("starPink")
        .resizable()
        .scaledToFit()
        .frame(height: 120)

      VStack(spacing: Spacing.xxs) {
        Text("\(streakCount) DAY\(streakCount == 1 ? "" : "S")")
          .typography(.title)
          .foregroundColor(.black)

        Text(motivationText)
          .typography(.subheadline)
          .foregroundColor(.black.opacity(0.7))
          .padding(.horizontal, Spacing.l)
          .multilineTextAlignment(.center)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, Spacing.m)
    .neobrutalismStyle(backgroundColor: AppColor.accentPurple)
    .onAppear {
      if streakCount > highestStreak {
        highestStreak = streakCount
      }
    }
  }
}
