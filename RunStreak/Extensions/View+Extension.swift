//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import SwiftUI

extension View {
  func pressedEffect() -> some View {
    modifier(PressedEffect())
  }

  func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
    block(self)
  }
}

struct PressedEffect: ViewModifier {
  @State private var isPressed = false

  func body(content: Content) -> some View {
    content
      .offset(y: isPressed ? 2 : 0)
      .animation(.easeInOut(duration: 0.1), value: isPressed)
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in
            if !isPressed { isPressed = true }
          }
          .onEnded { _ in
            isPressed = false
          }
      )
  }
}
