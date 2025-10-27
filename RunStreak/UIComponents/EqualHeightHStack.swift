//
//  EqualHeightHStack.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 27.10.25.
//

import SwiftUI

/// A container that ensures all child views in a horizontal stack share the same height.
/// Automatically adapts to the tallest item.
struct EqualHeightHStack<Content: View>: View {
  @ViewBuilder var content: Content
  @State private var maxHeight: CGFloat = 1

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      content
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

