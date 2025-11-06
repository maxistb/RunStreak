//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

/// A container that ensures all child views in a horizontal stack share the same height.
/// Automatically adapts to the tallest item.
public struct EqualHeightHStack<Content: View>: View {
  @ViewBuilder private let content: () -> Content
  @State private var maxHeight: CGFloat = 1

  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    HStack(alignment: .top, spacing: Spacing.s) {
      content()
        .fixedSize(horizontal: false, vertical: false)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                maxHeight = max(maxHeight, geo.size.height)
              }
              .onChange(of: geo.size.height) { _, newValue in
                maxHeight = max(maxHeight, newValue)
              }
          }
        )
        .frame(height: maxHeight)
    }
  }
}
