//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct TodayRunCard: View {
  private let distanceString: String

  public init(distanceString: String) {
    self.distanceString = distanceString
  }

  public var body: some View {
    HStack {
      Text("Today’s Run Complete ✅")
        .typography(.metricValue)

      Spacer()

      Text(distanceString)
        .typography(.metricValue)
    }
    .padding()
    .neobrutalismStyle(backgroundColor: AppColor.accentMint)
  }
}
