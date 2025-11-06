//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct BrutalistBadge: View {
  private let text: String
  private let color: Color
  private let icon: String?

  public init(text: String, color: Color, icon: String? = nil) {
    self.text = text
    self.color = color
    self.icon = icon
  }

  public var body: some View {
    HStack(spacing: Spacing.xxs) {
      if let icon { Image(systemName: icon) }
      Text(text.uppercased())
        .typography(.badge)
    }
    .foregroundColor(.black)
    .padding(.horizontal, Spacing.s)
    .padding(.vertical, Spacing.xxs)
    .neobrutalismStyle(backgroundColor: color)
  }
}
