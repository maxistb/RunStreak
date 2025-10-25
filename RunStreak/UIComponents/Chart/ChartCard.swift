//
//  ChartCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//


import SwiftUI

struct ChartCard<Content: View>: View {
  let title: String
  let content: Content

  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text(title)
        .font(.system(size: 17, weight: .semibold, design: .rounded))
        .foregroundColor(.white.opacity(0.85))
        .padding(.bottom, 2)

      content
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      ZStack {
        LinearGradient(
          colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
        Image("background01")
          .resizable()
          .scaledToFill()
          .opacity(0.06)
          .blendMode(.overlay)
      }
    )
    .cornerRadius(CornerRadius.large)
    .overlay(
      RoundedRectangle(cornerRadius: CornerRadius.large)
        .stroke(
          LinearGradient(
            colors: [AppColor.primary.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1
        )
    )
  }
}