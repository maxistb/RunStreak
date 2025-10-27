//
//  MetricDetailView.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 27.10.25.
//

import Charts
import SwiftUI

struct MetricDetailView<M: ChartMetric>: View {
  @State private var viewModel: MetricDetailViewModel<M>
  @State private var selectedDate: Date? = nil

  let title: String
  let unit: String
  let accentColor: Color
  let footerText: String

  private var selectedValue: (date: Date, value: Double)? {
    guard let selectedDate else { return nil }
    // Find the closest sample by date
    return viewModel.filteredSamples
      .min(by: { abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate)) })
      .map { ($0.date, $0.value) }
  }

  init(
    title: String,
    unit: String,
    accentColor: Color,
    footerText: String,
    samples: [M]
  ) {
    self._viewModel = State(initialValue: MetricDetailViewModel(samples: samples))
    self.title = title
    self.unit = unit
    self.accentColor = accentColor
    self.footerText = footerText
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        insights
        chartCard
        footer
      }
      .padding(.vertical, 24)
      .padding(.horizontal, 16)
    }
    .background(accentColor.ignoresSafeArea())
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }

  private var insights: some View {
    HStack(spacing: 16) {
      if let best = viewModel.bestSample {
        InsightPreviewButton(
          title: "Best Day",
          value: String(format: "%.1f %@", best.value, unit),
          icon: "trophy.fill",
          color: AppColor.accentPeach,
          hasTrailingArrow: false
        ) {}
      }

      if let totalRunningDistance = viewModel.totalRunningDistance {
        InsightPreviewButton(
          title: "Total Distance",
          value: String(format: "%.1f %@", totalRunningDistance, unit),
          icon: "figure.run",
          color: AppColor.accentMint,
          hasTrailingArrow: false
        ) {}
      }

      InsightPreviewButton(
        title: "This Period",
        value: String(format: "%.1f %@", viewModel.averageValue, unit),
        icon: "calendar",
        color: AppColor.accentPurple,
        hasTrailingArrow: false
      ) {}
    }
    .padding(.vertical, 4)
  }

  private var chartCard: some View {
    VStack(spacing: 16) {
      picker
      chart
    }
  }

  private var picker: some View {
    Button {} label: {
      Picker("Range", selection: $viewModel.selectedRange) {
        ForEach(TimeRange.allCases, id: \.self) { range in
          Text(range.label)
            .tag(range)
        }
      }
      .pickerStyle(.segmented)
      .padding(6)
    }
    .buttonStyle(
      NeobrutalistButtonStyle(
        cornerRadius: 20,
        shadowOffset: 4,
        borderColor: .black,
        backgroundColor: .white
      )
    )
  }

  private var chart: some View {
    Chart {
      ForEach(viewModel.filteredSamples) { sample in
        AreaMark(
          x: .value("Date", sample.date),
          y: .value(title, sample.value)
        )
        .interpolationMethod(.catmullRom)
        .foregroundStyle(
          LinearGradient(
            colors: [Color.black.opacity(0.3), .clear],
            startPoint: .top,
            endPoint: .bottom
          )
        )

        LineMark(
          x: .value("Date", sample.date),
          y: .value(title, sample.value)
        )
        .interpolationMethod(.catmullRom)
        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
        .foregroundStyle(.black)
      }

      if let selectedValue {
        RuleMark(x: .value("Selected", selectedValue.date))
          .foregroundStyle(.black)
          .lineStyle(StrokeStyle(lineWidth: 1, dash: [3]))
          .annotation(position: .top, spacing: 8) {
            selectedValueView
          }
      }
    }
    .chartXSelection(value: $selectedDate)
    .chartYScale(domain: 0 ... (viewModel.filteredSamples.map(\.value).max() ?? 1))
    .chartXScale(domain:
      viewModel.filteredSamples.map { $0.date }.min()! ... viewModel.filteredSamples.map { $0.date }.max()!
    )

    .frame(height: 240)
  }

  @ViewBuilder
  private var selectedValueView: some View {
    if let value = selectedValue {
      Button {} label: {
        VStack(alignment: .trailing, spacing: 6) {
          Text("\(value.date.formatted(date: .abbreviated, time: .omitted))")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.black)

          Text("\(String(format: "%.1f", value.value)) \(unit)")
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.black)
        }
        .padding(10)
      }
      .buttonStyle(
        NeobrutalistButtonStyle(
          cornerRadius: 20,
          shadowOffset: 3,
          borderColor: .black,
          backgroundColor: .white
        )
      )
    }
  }

  private var footer: some View {
    Text(footerText)
      .multilineTextAlignment(.center)
      .font(.system(size: 15, weight: .medium))
      .foregroundColor(.black.opacity(0.8))
      .padding(.horizontal)
      .padding(.bottom, 40)
  }
}
