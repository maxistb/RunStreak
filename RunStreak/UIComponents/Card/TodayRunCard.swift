//
//  TodayRunCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct TodayRunCard: View {
  let distanceString: String

  var body: some View {
    Button {} label: {
      HStack {
        Text("Today’s Run Complete ✅")
          .font(.system(size: 18, weight: .bold, design: .rounded))
        Spacer()
        Text(distanceString)
          .font(.system(size: 18, weight: .bold, design: .rounded))
      }
      .padding()
    }
    .buttonStyle(
      NeobrutalistButtonStyle(
        cornerRadius: 20,
        shadowOffset: 4,
        borderColor: .black,
        backgroundColor: AppColor.accentMint
      )
    )
  }
}
