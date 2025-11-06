//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI

public struct DonationCards: View {
  public init() {}

  public var body: some View {
    VStack(spacing: Spacing.xs) {
      HStack {
        Text("Support RunStreak")
          .font(.system(size: 22, weight: .bold, design: .rounded))
          .foregroundColor(.black)
          .multilineTextAlignment(.center)

        LottieSwiftUIView(name: "coffee")
          .frame(width: 100, height: 100)
          .padding(.horizontal, -30)
          .padding(.vertical, -20)
      }

      cardView(image: Image("starIllu"), color: AppColor.accentMint)
        .rotationEffect(.degrees(-10))
        .scaleEffect(0.8)
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(x: -70)
        .overlay(alignment: .leading) {
          cardView(image: Image("heartIllu"), color: AppColor.accentLilac)
            .rotationEffect(.degrees(10))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(x: -50)
        }
        .padding(.top, Spacing.m)

      VStack(spacing: Spacing.xs) {
        Text("This app is 100% free and open source. If you enjoy using RunStreak and want to help keep it ad-free and growing, consider buying me a coffee ☕️ — it means the world!")
          .typography(.subheadline)
          .foregroundColor(.black.opacity(0.75))
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, Spacing.m)
          .padding(.top, Spacing.xs)

        Text("Donate ❤️")
          .typography(.heading)
          .foregroundColor(.black)
          .padding(.vertical, Spacing.xs)
          .frame(maxWidth: .infinity)
          .neobrutalismStyle(backgroundColor: AppColor.accentPeach, onClick: openDonationPage)
          .padding(.horizontal, Spacing.m)
          .padding(.vertical, Spacing.xs)
      }
    }
    .padding(.vertical, Spacing.m)
    .padding(.bottom, 1_000)
    .background(AppColor.accentPink)
    .padding(.bottom, -1_010)
  }

  private func cardView(image: Image, color: Color) -> some View {
    image
      .resizable()
      .scaledToFit()
      .frame(width: 180, height: 260)
      .neobrutalismStyle(backgroundColor: color)
  }

  private func openDonationPage() {
    if let url = URL(string: "https://buymeacoffee.com/runningstreak") {
      UIApplication.shared.open(url)
    }
  }
}
