//
//  SectionHeader.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct SectionHeader: View {
  let title: String

  var body: some View {
    HStack {
      Text(title.uppercased())
        .font(.system(size: 14, weight: .heavy))
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(AppColor.primary)
        .cornerRadius(6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.black, lineWidth: 2)
        )
        .shadow(color: .black, radius: 0, x: 4, y: 4)

      Spacer()
    }
    .padding(.vertical, 8)
  }
}
