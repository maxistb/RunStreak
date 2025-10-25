//
//  RunRow.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct RunListRow: View {
  let run: RunDay

  private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, h:mm a"
    return formatter.string(from: run.date)
  }

  private var formattedDuration: String {
    let minutes = Int(run.durationInSeconds / 60)
    return "\(minutes) min"
  }

  private var avgHeartRate: Int {
    Int.random(in: 145 ... 170)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(String(format: "%.1f km", run.distanceInMeters / 1000))
          .font(.system(size: 22, weight: .heavy, design: .rounded))
          .foregroundColor(.black)
          .padding(6)
          .background(AppColor.primary)
          .cornerRadius(6)
          .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 2))

        Spacer()

        Text(formattedDate)
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.black)
          .padding(6)
          .background(AppColor.secondary.opacity(0.8))
          .cornerRadius(6)
          .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 2))
      }

      HStack(spacing: 16) {
        Label(formattedDuration, systemImage: "clock.fill")
          .labelStyle(IconTextLabelStyle(iconColor: .black))
        Label(run.formattedPace, systemImage: "figure.run")
          .labelStyle(IconTextLabelStyle(iconColor: AppColor.success))
        Label("\(avgHeartRate) bpm", systemImage: "heart.fill")
          .labelStyle(IconTextLabelStyle(iconColor: .red))
      }
      .font(.system(size: 14, weight: .semibold))
      .foregroundColor(.black)
    }
    .padding()
    .background(AppColor.background)
    .cornerRadius(12)
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 2))
    .shadow(color: .black, radius: 0, x: 4, y: 4)
    .padding(.vertical, 4)
  }
}

struct IconTextLabelStyle: LabelStyle {
  var iconColor: Color

  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 6) {
      configuration.icon.foregroundColor(iconColor)
      configuration.title
    }
  }
}
