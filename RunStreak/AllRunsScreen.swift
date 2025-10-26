//
//  AllRunsScreen.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftUI

struct AllRunsScreen: View {
  let runs: [RunDay]

  private var groupedRuns: [(key: String, value: [RunDay])] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"

    let grouped = Dictionary(grouping: runs) { run in
      dateFormatter.string(from: run.date)
    }

    return grouped.sorted {
      guard let d1 = DateFormatter.monthYear.date(from: $0.key),
            let d2 = DateFormatter.monthYear.date(from: $1.key) else { return false }
      return d1 > d2
    }
  }

  var body: some View {
    ZStack {
      AppColor.background.ignoresSafeArea()

      List {
        ForEach(groupedRuns, id: \.key) { month, runs in
//          Section(header: SectionHeader(title: month)) {
//            ForEach(runs.sorted(by: { $0.date > $1.date }), id: \.uuid) { run in
//              RunListRow(run: run)
//                .listRowBackground(Color.clear)
//                .listRowSeparator(.hidden)
//            }
//          }
          Text("")
        }
      }
      .scrollContentBackground(.hidden)
      .listStyle(.plain)
    }
    .navigationTitle("All Runs")
    .navigationBarTitleDisplayMode(.inline)
    .preferredColorScheme(.dark)
  }
}

extension DateFormatter {
  static let monthYear: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MMMM yyyy"
    return df
  }()
}
