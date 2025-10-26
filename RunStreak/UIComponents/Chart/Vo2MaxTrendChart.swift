//
//  Vo2MaxTrendChart.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Charts
import SwiftUI

struct Vo2MaxTrendChart: View {
  let runs: [RunDay]

  private var groupedSamples: [DailyVo2Max] {
    let calendar = Calendar.current
    let now = Date()
    let oneMonthAgo = calendar.date(byAdding: .day, value: -30, to: now)!
    let recentRuns = runs.filter { $0.date >= oneMonthAgo && $0.vo2Max != nil }

    let grouped = Dictionary(grouping: recentRuns, by: { calendar.startOfDay(for: $0.date) })

    return grouped.map { date, runsOnDate in
      let avgVo2 = runsOnDate.compactMap { $0.vo2Max }.reduce(0, +) / Double(runsOnDate.count)
      return DailyVo2Max(date: date, vo2: avgVo2)
    }
    .sorted { $0.date < $1.date }
  }

  var body: some View {
    ChartCard(title: "VO₂ Max (30 Days)") {
      if groupedSamples.isEmpty {
        EmptyChartPlaceholder()
      } else {
        Chart(groupedSamples) { day in
          AreaMark(
            x: .value("Date", day.date),
            y: .value("VO₂ Max", day.vo2)
          )
          .foregroundStyle(
            LinearGradient(
              colors: [AppColor.background.opacity(0.3), .clear],
              startPoint: .top,
              endPoint: .bottom
            )
          )

          LineMark(
            x: .value("Date", day.date),
            y: .value("VO₂ Max", day.vo2)
          )
          .lineStyle(.init(lineWidth: 2, lineCap: .round))
          .foregroundStyle(AppColor.background)
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

struct DailyVo2Max: Identifiable {
  let id = UUID()
  let date: Date
  let vo2: Double
}
