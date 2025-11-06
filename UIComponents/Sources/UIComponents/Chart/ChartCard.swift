//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct ChartCard<Content: View>: View {
  @ViewBuilder private var content: Content
  private let title: String
  private let accentColor: Color

  public init(
    title: String,
    accentColor: Color,
    content: @escaping () -> Content
  ) {
    self.content = content()
    self.title = title
    self.accentColor = accentColor
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: Spacing.m) {
      content
    }
    .padding()
  }
}
