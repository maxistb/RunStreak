//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import SwiftUI

/// Global font scale for RunStreak, inspired by Apple’s Human Interface Guidelines
/// and adjusted for the app’s neobrutalist design language.
public enum FontStyle {
  // MARK: - Display / Title

  /// Large hero titles (e.g., on HomeScreen greeting)
  case largeTitle

  /// Section titles or major screen headers (e.g., "Distance", "Heart Rate")
  case title

  /// Subheadings or cards headers
  case heading

  // MARK: - Body & Supporting

  /// Default text style for paragraphs or metric labels
  case body

  /// Slightly smaller text for secondary descriptions
  case subheadline

  /// Captions and helper text under charts or badges
  case caption

  // MARK: - UI Elements

  /// Font used for Insight buttons and chart annotations
  case metricValue

  /// Used in badges, pill labels, and buttons (e.g., “NEW RECORD”)
  case badge

  /// For small emphasized labels or footnotes
  case footnote

  /// Chart axis / data value annotations
  case chartLabel

  // MARK: - Accessor

  var font: Font {
    switch self {
      // MARK: Display / Title

      case .largeTitle:
        return .system(size: 36, weight: .heavy, design: .rounded)

      case .title:
        return .system(size: 28, weight: .bold, design: .rounded)

      case .heading:
        return .system(size: 22, weight: .semibold, design: .rounded)

      // MARK: Body & Supporting

      case .body:
        return .system(size: 17, weight: .regular, design: .rounded)

      case .subheadline:
        return .system(size: 15, weight: .medium, design: .rounded)

      case .caption:
        return .system(size: 13, weight: .medium, design: .rounded)

      // MARK: UI Elements

      case .metricValue:
        return .system(size: 20, weight: .bold, design: .rounded)

      case .badge:
        return .system(size: 12, weight: .heavy, design: .rounded)

      case .footnote:
        return .system(size: 11, weight: .medium, design: .rounded)

      case .chartLabel:
        return .system(size: 10, weight: .regular, design: .rounded)
    }
  }
}

public extension View {
  /// Convenient helper to apply your global font style:
  /// ```swift
  /// Text("VO₂Max").typography(.heading)
  /// ```
  func typography(_ style: FontStyle) -> some View {
    self.font(style.font)
  }
}
