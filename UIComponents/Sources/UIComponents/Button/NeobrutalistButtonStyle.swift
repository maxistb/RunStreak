//
//  NeobrutalistButtonStyle.swift
//  UIComponents
//
//  Created by Maximillian Stabe on 02.11.25.
//

import Styleguide
import SwiftUI

public struct NeobrutalistButtonStyle: ButtonStyle {
  private let cornerRadius: CGFloat
  private let shadowOffset: CGFloat
  private let borderColor: Color
  private let backgroundColor: Color

  public init(
    cornerRadius: CGFloat = CornerRadius.m,
    shadowOffset: CGFloat = 5,
    borderColor: Color = .black,
    backgroundColor: Color = AppColor.background
  ) {
    self.cornerRadius = cornerRadius
    self.shadowOffset = shadowOffset
    self.borderColor = borderColor
    self.backgroundColor = backgroundColor
  }

  public func makeBody(configuration: Configuration) -> some View {
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
