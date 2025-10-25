//
//  InsightPreviewButton.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 25.10.25.
//

import SwiftUI

struct InsightPreviewButton<Destination: View>: View {
  let title: String
  let value: String
  let icon: String
  let color: Color
  let destination: () -> Destination

  var body: some View {
    NavigationLink(destination: destination()) {
      VStack(alignment: .leading, spacing: 8) {
        Image(systemName: icon)
          .font(.system(size: 20))
          .padding(10)
          .background(color)
          .clipShape(Circle())

        Text(title)
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(AppColor.textSecondary)

        Text(value)
          .font(.system(size: 17, weight: .bold, design: .rounded))
          .foregroundColor(AppColor.textPrimary)

        Spacer()
      }
      .padding()
      .frame(width: 150, height: 120, alignment: .topLeading)
      .background(AppColor.card)
      .cornerRadius(20)
      .shadow(color: color.opacity(0.3), radius: 6, y: 4)
    }
    .buttonStyle(PlainButtonStyle())
  }
}
