//
//  BrutalistBadge.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 31.10.25.
//

import SwiftUI

struct BrutalistBadge: View {
  var text: String
  var color: Color
  var icon: String?
  var shadowOffset: CGFloat = 4

  var body: some View {
    HStack(spacing: 6) {
      if let icon { Image(systemName: icon) }
      Text(text.uppercased())
        .font(.system(size: 13, weight: .bold))
    }
    .foregroundColor(.black)
    .padding(.horizontal, 14)
    .padding(.vertical, 8)
    .background(color)
    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.black, lineWidth: 2))
    .cornerRadius(14)
    .shadow(color: .black, radius: 0, x: shadowOffset, y: shadowOffset)
  }
}
