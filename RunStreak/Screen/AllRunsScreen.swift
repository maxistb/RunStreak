//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Styleguide
import SwiftUI
import UIComponents

private struct YearMonth: Hashable, Comparable {
  let year: Int
  let month: Int

  static func < (lhs: YearMonth, rhs: YearMonth) -> Bool {
    if lhs.year != rhs.year {
      return lhs.year < rhs.year
    }
    return lhs.month < rhs.month
  }
}

struct AllRunsScreen: View {
  let runs: [RunDay]
  let distanceUnit: MetricUnit = .km

  private var groupedRuns: [(key: YearMonth, monthName: String, runs: [RunDay])] {
    let calendar = Calendar.current

    let grouped = Dictionary(grouping: runs) { run -> YearMonth in
      let comps = calendar.dateComponents([.year, .month], from: run.date)
      return YearMonth(year: comps.year ?? 0, month: comps.month ?? 0)
    }

    return grouped.map { key, value in
      let monthIndex = max(0, min(key.month - 1, calendar.monthSymbols.count - 1))
      let monthName = calendar.monthSymbols[monthIndex]
      return (key, monthName, value.sorted(by: { $0.date > $1.date }))
    }
    .sorted(by: { $0.key > $1.key })
  }

  var body: some View {
    List {
      ForEach(groupedRuns, id: \.key) { group in
        Section(header: sectionHeader(for: group)) {
          ForEach(group.runs.sorted(by: { $0.date > $1.date }), id: \.uuid) { run in
            RunRow(run: run, distanceUnit: distanceUnit)
              .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
              .listRowSeparator(.hidden)
              .listRowBackground(Color.clear)
          }
        }
      }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(AppColor.background.ignoresSafeArea())
    .navigationTitle("All Runs")
    .navigationBarTitleDisplayMode(.inline)
  }

  private func sectionHeader(for group: (key: YearMonth, monthName: String, runs: [RunDay])) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 2) {
        Text(group.monthName.uppercased())
          .typography(.heading)
          .foregroundColor(.black)

        Text(String(group.key.year))
          .typography(.caption)
          .foregroundColor(.black.opacity(0.8))
      }

      Spacer()

      Text("\(group.runs.count) run\(group.runs.count == 1 ? "" : "s")")
        .typography(.subheadline)
        .foregroundColor(.black)
        .padding(.vertical, Spacing.xxs)
        .padding(.horizontal, Spacing.xs)
        .background(AppColor.accentMint)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
        .cornerRadius(CornerRadius.s)
        .shadow(color: .black, radius: 0, x: 3, y: 3)
    }
    .padding(Spacing.xxs)
    .neobrutalismStyle(backgroundColor: AppColor.accentPurple)
  }
}

private struct RunRow: View {
  private let run: RunDay
  private let distanceUnit: MetricUnit

  init(run: RunDay, distanceUnit: MetricUnit) {
    self.run = run
    self.distanceUnit = distanceUnit
  }

  var body: some View {
    HStack(spacing: Spacing.s) {
      ZStack {
        Circle()
          .fill(AppColor.accentBlue)
          .frame(width: 48, height: 48)
          .overlay(Circle().stroke(.black, lineWidth: 2))
        Image(systemName: "figure.run")
          .typography(.heading)
          .foregroundColor(.black)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(run.date.formatted(date: .abbreviated, time: .shortened))
          .typography(.subheadline)
          .foregroundColor(.black)

        HStack(spacing: Spacing.xs) {
          Label("\(formattedDistance(run.distanceInMeters))", systemImage: "ruler")
          Label(formatDuration(run.durationInSeconds), systemImage: "clock")
          if let hr = run.avgHeartRate {
            Label("\(Int(hr)) bpm", systemImage: "heart.fill")
          }
        }
        .typography(.caption)
        .foregroundColor(.black.opacity(0.8))
      }

      Spacer()
    }
    .padding()
    .neobrutalismStyle(backgroundColor: AppColor.accentMint)
  }

  private func formattedDistance(_ meters: Double) -> String {
    let converted = distanceUnit.convertDistance(meters / 1_000)
    return String(format: "%.1f %@", converted, distanceUnit.unitSymbol)
  }

  private func formatDuration(_ seconds: Double) -> String {
    let minutes = Int(seconds / 60)
    let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
    return "\(minutes)m \(secs)s"
  }
}
