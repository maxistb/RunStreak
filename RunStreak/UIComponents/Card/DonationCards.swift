//
//  DonationCard.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 26.10.25.
//

import SwiftUI

struct DonationCards: View {
  var body: some View {
    VStack(spacing: 12) {
      Text("Support RunStreak 💛")
        .font(.system(size: 22, weight: .bold, design: .rounded))
        .foregroundColor(.black)
        .multilineTextAlignment(.center)

      cardView(image: Image(.starIllu), color: AppColor.accentMint)
        .rotationEffect(.degrees(-10))
        .scaleEffect(0.8)
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(x: -70)
        .overlay(alignment: .leading) {
          cardView(image: Image(.heartIllu), color: AppColor.accentLilac)
            .rotationEffect(.degrees(10))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(x: -50)
        }
        .padding(.top, 20)

      VStack(spacing: 10) {
        Text("This app is 100% free and open source. If you enjoy using RunStreak and want to help keep it ad-free and growing, consider buying me a coffee ☕️ — it means the world!")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(.black.opacity(0.75))
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, 20)
          .padding(.top, 12)

        Button(action: openDonationPage) {
          Text("Donate ❤️")
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .buttonStyle(
          NeobrutalistButtonStyle(
            cornerRadius: 20,
            shadowOffset: 3,
            borderColor: .black,
            backgroundColor: AppColor.accentPeach
          )
        )
        .padding(.vertical, 12)
      }
    }
    .padding(.vertical, 20)
    .background(AppColor.accentRed)
  }

  private func cardView(image: Image, color: Color) -> some View {
    image
      .resizable()
      .scaledToFit()
      .frame(width: 180, height: 260)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(color)
          .stroke(Color.black, lineWidth: 2)
      )
  }

  private func openDonationPage() {
    if let url = URL(string: "https://www.buymeacoffee.com/yourname") {
      UIApplication.shared.open(url)
    }
  }
}
