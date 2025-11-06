//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Charts
import Styleguide
import SwiftUI
import UIComponents

enum MetricUnit {
  case km
  case bpm
  case vo2Max

  func convertDistance(_ value: Double) -> Double {
    switch self {
      case .km:
        Locale.current.measurementSystem == .metric ? value : value / 1.60934
      case .bpm:
        value
      case .vo2Max:
        value
    }
  }

  var unitSymbol: String {
    switch self {
      case .km:
        Locale.current.measurementSystem == .metric ? "km" : "mi"
      case .bpm:
        "bpm"
      case .vo2Max:
        "ml/kg/min"
    }
  }
}

struct MetricDetailView<M: ChartMetric>: View {
  @State private var viewModel: MetricDetailViewModel<M>
  @State private var selectedDate: Date? = nil

  let title: String
  let unit: MetricUnit
  let accentColor: Color
  let footerText: String
  let measurementSystem: Locale.MeasurementSystem

  private var selectedValue: (date: Date, value: Double)? {
    guard let selectedDate else { return nil }
    return viewModel.filteredSamples
      .min(by: { abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate)) })
      .map { ($0.date, $0.value) }
  }

  init(
    title: String,
    unit: MetricUnit,
    accentColor: Color,
    footerText: String,
    samples: [M],
    measurementSystem: Locale.MeasurementSystem = Locale.current.measurementSystem
  ) {
    self._viewModel = State(initialValue: MetricDetailViewModel(samples: samples))
    self.title = title
    self.unit = unit
    self.accentColor = accentColor
    self.footerText = footerText
    self.measurementSystem = measurementSystem
  }

  var body: some View {
    ScrollView {
      VStack(spacing: Spacing.m) {
        insights
        chartCard
        footer
      }
      .padding(.vertical, Spacing.m)
      .padding(.horizontal, Spacing.s)
    }
    .background(accentColor.ignoresSafeArea())
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }

  // MARK: - Insights

  private var insights: some View {
    EqualHeightHStack {
      if let best = viewModel.bestSample {
        InsightPreviewButton(
          title: "Best Day",
          value: formattedDistance(best.value),
          icon: "trophy.fill",
          color: AppColor.accentPeach,
          hasTrailingArrow: false
        ) {}
      }

      if let totalRunningDistance = viewModel.totalRunningDistance {
        InsightPreviewButton(
          title: "Total Distance",
          value: formattedDistance(totalRunningDistance),
          icon: "figure.run",
          color: AppColor.accentMint,
          hasTrailingArrow: false
        ) {}
      }

      InsightPreviewButton(
        title: "This Period",
        value: formattedDistance(viewModel.averageValue),
        icon: "calendar",
        color: AppColor.accentPurple,
        hasTrailingArrow: false
      ) {}
    }
    .padding(.vertical, Spacing.xxxs)
  }

  // MARK: - Chart Card

  private var chartCard: some View {
    VStack(spacing: Spacing.s) {
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
      .padding(Spacing.xxs)
    }
    .neobrutalismStyle(backgroundColor: .white)
  }

  private var chart: some View {
    Chart {
      ForEach(viewModel.filteredSamples) { sample in
        AreaMark(
          x: .value("Date", sample.date),
          y: .value(title, convertedValue(sample.value))
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
          y: .value(title, convertedValue(sample.value))
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
    .chartXScale(domain: (viewModel.filteredSamples.map { $0.date }.min() ?? .now) ... (viewModel.filteredSamples.map { $0.date }.max() ?? .now)
    )
    .frame(height: 240)
  }

  @ViewBuilder
  private var selectedValueView: some View {
    if let value = selectedValue {
      VStack(alignment: .trailing, spacing: 6) {
        Text("\(value.date.formatted(date: .abbreviated, time: .omitted))")
          .typography(.caption)
          .foregroundColor(.black)

        Text(formattedDistance(value.value))
          .typography(.body)
          .foregroundColor(.black)
      }
      .padding(10)
      .neobrutalismStyle(backgroundColor: .white)
    }
  }

  private var footer: some View {
    Text(footerText)
      .multilineTextAlignment(.center)
      .typography(.subheadline)
      .foregroundColor(.black.opacity(0.8))
      .padding(.horizontal)
      .padding(.bottom, Spacing.xl)
  }

  private func convertedValue(_ km: Double) -> Double {
    unit.convertDistance(km)
  }

  private func formattedDistance(_ km: Double) -> String {
    return String(format: "%.1f %@", unit.convertDistance(km), unit.unitSymbol)
  }
}
