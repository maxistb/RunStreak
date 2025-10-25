//
//  DistanceTrendChart.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import Charts
import SwiftUI

struct DailyDistance: Identifiable {
  let id = UUID()
  let date: Date
  let km: Double
}

struct DistanceTrendChart: View {
  let runs: [RunDay]

  private var groupedRuns: [DailyDistance] {
    let calendar = Calendar.current
    let now = Date()
    let oneMonthAgo = calendar.date(byAdding: .day, value: -30, to: now)!
    let recent = runs.filter { $0.date >= oneMonthAgo }

    return Dictionary(grouping: recent, by: { calendar.startOfDay(for: $0.date) })
      .map { date, runs in
        DailyDistance(date: date, km: runs.reduce(0) { $0 + $1.distanceInMeters / 1000 })
      }
      .sorted { $0.date < $1.date }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Run Distance (30 Days)")
        .font(.system(size: 14, weight: .heavy))
        .foregroundColor(.white)

      Chart(groupedRuns) { day in
        LineMark(
          x: .value("Date", day.date),
          y: .value("km", day.km)
        )
        .foregroundStyle(AppColor.primary)
        .lineStyle(.init(lineWidth: 3, lineCap: .round))
      }
      .chartXAxis {
        AxisMarks(values: .stride(by: .day, count: 7)) {
          AxisValueLabel(format: .dateTime.day().month(.abbreviated), centered: true)
        }
      }
      .chartYAxis {
        AxisMarks {
          AxisValueLabel(format: Decimal.FormatStyle.number.precision(.fractionLength(0)))
        }
      }
      .frame(height: 140)
    }
    .padding()
    .background(AppColor.surface)
    .cornerRadius(10)
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
    .shadow(color: AppColor.secondary.opacity(0.6), radius: 0, x: 5, y: 5)
  }
}
