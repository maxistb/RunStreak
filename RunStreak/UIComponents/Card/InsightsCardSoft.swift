//
//  InsightsCardSoft.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 25.10.25.
//

import SwiftUI

struct InsightsCard: View {
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 8) {
        Text("Feeling Strong 💪")
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(AppColor.textPrimary)
        Text("You’ve increased your average pace this week!")
          .font(.system(size: 15))
          .foregroundColor(AppColor.textSecondary)
      }
      Spacer()
    }
    .padding()
    .background(AppColor.accentBlue)
    .cornerRadius(20)
    .shadow(color: AppColor.accentBlue.opacity(0.4), radius: 10, y: 6)
    .padding(.horizontal)
  }
}
