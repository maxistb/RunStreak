//
//  InsightPreviewButton.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 25.10.25.
//

import SwiftUI

struct InsightPreviewButton: View {
  private let title: String
  private let subtitle: String?
  private let value: String
  private let icon: String
  private let color: Color
  private let hasTrailingArrow: Bool
  private let onClick: () -> Void

  init(
    title: String,
    subtitle: String? = nil,
    value: String,
    icon: String,
    color: Color,
    hasTrailingArrow: Bool,
    onClick: @escaping () -> Void
  ) {
    self.title = title
    self.subtitle = subtitle
    self.value = value
    self.icon = icon
    self.color = color
    self.hasTrailingArrow = hasTrailingArrow
    self.onClick = onClick
  }

  var body: some View {
    Button {
      onClick()
    } label: {
      VStack(alignment: hasTrailingArrow ? .leading : .center, spacing: 10) {
        Image(systemName: icon)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.black)
          .padding(10)
          .background(AppColor.background)
          .clipShape(Circle())
          .overlay(
            Circle()
              .stroke(Color.black, lineWidth: 2)
          )

        Text(title.uppercased())
          .font(.system(size: 13, weight: .bold))
          .foregroundColor(.black.opacity(0.8))
          .multilineTextAlignment(hasTrailingArrow ? .leading : .center)

        Text(value)
          .font(.system(size: 18, weight: .heavy, design: .rounded))
          .foregroundColor(.black)
          .multilineTextAlignment(hasTrailingArrow ? .leading : .center)

        if let subtitle = subtitle {
          Text(subtitle)
            .foregroundStyle(.secondary)
        }
      }
      .padding()
      .apply {
        if hasTrailingArrow {
          $0
            .frame(width: 150, alignment: .leading)
            .overlay(alignment: .trailing) {
              Image(systemName: "chevron.right")
                .foregroundStyle(.black)
                .padding(.trailing, 8)
            }
        } else {
          $0
            .frame(maxWidth: .infinity)
        }
      }
    }
    .buttonStyle(
      NeobrutalistButtonStyle(
        cornerRadius: 20,
        shadowOffset: 3,
        borderColor: .black,
        backgroundColor: color
      )
    )
    .padding(.vertical, 4)
  }
}

struct NeobrutalistButtonStyle: ButtonStyle {
  var cornerRadius: CGFloat = 16
  var shadowOffset: CGFloat = 5
  var borderColor: Color = .black
  var backgroundColor: Color = AppColor.background

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(backgroundColor)
          .shadow(
            color: borderColor,
            radius: 0,
            x: configuration.isPressed ? 0 : shadowOffset,
            y: configuration.isPressed ? 0 : shadowOffset
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(borderColor, lineWidth: 2)
      )
      .offset(
        x: configuration.isPressed ? shadowOffset : 0,
        y: configuration.isPressed ? shadowOffset : 0
      )
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}
