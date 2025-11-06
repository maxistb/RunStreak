//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct InsightPreviewButton: View {
  private let title: String
  private let subtitle: String?
  private let value: String
  private let icon: String
  private let color: Color
  private let hasTrailingArrow: Bool
  private let onClick: () -> Void

  public init(
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

  public var body: some View {
    Button {
      onClick()
    } label: {
      VStack(alignment: hasTrailingArrow ? .leading : .center, spacing: Spacing.xs) {
        Image(systemName: icon)
          .typography(.metricValue)
          .foregroundColor(.black)
          .padding(Spacing.xs)
          .background(AppColor.background)
          .clipShape(Circle())
          .overlay(
            Circle()
              .stroke(Color.black, lineWidth: 2)
          )

        VStack(alignment: hasTrailingArrow ? .leading : .center, spacing: Spacing.xxxs) {
          Text(title.uppercased())
            .typography(.badge)
            .foregroundColor(.black.opacity(0.8))
            .multilineTextAlignment(hasTrailingArrow ? .leading : .center)

          Text(value)
            .typography(.metricValue)
            .foregroundColor(.black)
            .multilineTextAlignment(hasTrailingArrow ? .leading : .center)

          if let subtitle = subtitle {
            Text(subtitle)
              .foregroundStyle(.secondary)
          }
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
    .buttonStyle(NeobrutalistButtonStyle(backgroundColor: color))
  }
}
