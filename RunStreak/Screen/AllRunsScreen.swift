//
//  AllRunsScreen.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

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
          .font(.system(size: 16, weight: .heavy))
          .foregroundColor(.black)

        Text(String(group.key.year))
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(.black.opacity(0.8))
      }

      Spacer()

      Text("\(group.runs.count) run\(group.runs.count == 1 ? "" : "s")")
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(.black)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(AppColor.accentMint)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 2))
        .cornerRadius(8)
        .shadow(color: .black, radius: 0, x: 3, y: 3)
    }
    .padding(8)
    .background(AppColor.accentPurple)
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.black, lineWidth: 2))
    .cornerRadius(12)
    .shadow(color: .black, radius: 0, x: 4, y: 4)
    .padding(.vertical, 6)
  }
}

struct RunRow: View {
  let run: RunDay
  let distanceUnit: MetricUnit

  var body: some View {
    HStack(spacing: 16) {
      ZStack {
        Circle()
          .fill(AppColor.accentBlue)
          .frame(width: 48, height: 48)
          .overlay(Circle().stroke(.black, lineWidth: 2))
        Image(systemName: "figure.run")
          .font(.system(size: 22, weight: .bold))
          .foregroundColor(.black)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(run.date.formatted(date: .abbreviated, time: .shortened))
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(.black)

        HStack(spacing: 12) {
          Label("\(formattedDistance(run.distanceInMeters))", systemImage: "ruler")
          Label(formatDuration(run.durationInSeconds), systemImage: "clock")
          if let hr = run.avgHeartRate {
            Label("\(Int(hr)) bpm", systemImage: "heart.fill")
          }
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.black.opacity(0.8))
      }

      Spacer()
    }
    .padding()
    .background(AppColor.accentMint)
    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.black, lineWidth: 2))
    .cornerRadius(20)
    .shadow(color: .black, radius: 0, x: 4, y: 4)
  }

  private func formattedDistance(_ meters: Double) -> String {
    let converted = distanceUnit.convertDistance(meters / 1000)
    return String(format: "%.1f %@", converted, distanceUnit.unitSymbol)
  }

  private func formatDuration(_ seconds: Double) -> String {
    let minutes = Int(seconds / 60)
    let secs = Int(seconds.truncatingRemainder(dividingBy: 60))
    return "\(minutes)m \(secs)s"
  }
}
