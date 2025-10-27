//
//  ChartCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Charts
import SwiftUI

struct ChartCard<Content: View>: View {
  let title: String
  let accentColor: Color
  @ViewBuilder var content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
 
      content
    }
    .padding()
  }
}
