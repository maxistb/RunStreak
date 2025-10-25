//
//  HeartRateTrendChart.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Charts
import SwiftUI

struct HeartRateTrendChart: View {
  let runs: [RunDay]

  private var groupedSamples: [DailyHeartRate] {
    let calendar = Calendar.current
    let now = Date()
    let oneMonthAgo = calendar.date(byAdding: .day, value: -30, to: now)!

    let recentRuns = runs.filter { $0.date >= oneMonthAgo && $0.avgHeartRate != nil }

    let grouped = Dictionary(grouping: recentRuns, by: { calendar.startOfDay(for: $0.date) })

    return grouped.map { date, runsOnDate in
      let avgBpm = runsOnDate.compactMap { $0.avgHeartRate }.reduce(0, +) / Double(runsOnDate.count)
      return DailyHeartRate(date: date, bpm: avgBpm)
    }
    .sorted { $0.date < $1.date }
  }

  var body: some View {
    ChartCard(title: "Heart Rate (30 Days)") {
      if groupedSamples.isEmpty {
        EmptyChartPlaceholder()
      } else {
        Chart(groupedSamples) { day in
          AreaMark(
            x: .value("Date", day.date),
            y: .value("BPM", day.bpm)
          )
          .foregroundStyle(
            LinearGradient(
              colors: [AppColor.secondary.opacity(0.3), .clear],
              startPoint: .top,
              endPoint: .bottom
            )
          )

          LineMark(
            x: .value("Date", day.date),
            y: .value("BPM", day.bpm)
          )
          .lineStyle(.init(lineWidth: 2, lineCap: .round))
          .foregroundStyle(AppColor.secondary)
          .interpolationMethod(.catmullRom)
        }
        .chartXAxis {
          AxisMarks(values: .stride(by: .day, count: 5)) { _ in
            AxisValueLabel(format: .dateTime.day().month(.abbreviated))
          }
        }
        .chartYAxis {
          AxisMarks(position: .leading) {
            AxisGridLine().foregroundStyle(.white.opacity(0.1))
            AxisValueLabel(format: Decimal.FormatStyle.number.precision(.fractionLength(0)))
          }
        }
        .frame(height: 150)
        .padding(.vertical, 4)
      }
    }
  }
}

struct DailyHeartRate: Identifiable {
  let id = UUID()
  let date: Date
  let bpm: Double
}
