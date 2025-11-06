//
//  View+Extension.swift
//  UIComponents
//
//  Created by Maximillian Stabe on 02.11.25.
//

import SwiftUI

public extension View {
  func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
    block(self)
  }

  func neobrutalismStyle(backgroundColor: Color, onClick: (() -> Void)? = nil) -> some View {
    Button {
      onClick?()
    } label: {
      self
    }
    .buttonStyle(
      NeobrutalistButtonStyle(backgroundColor: backgroundColor)
    )
  }
}
