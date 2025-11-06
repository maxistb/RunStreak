//
// Copyright © 2025 Maximillian Stabe. All rights reserved.
//

import Foundation

@Observable
final class MetricDetailViewModel<M: ChartMetric> {
  private(set) var samples: [M]
  var selectedRange: TimeRange = .days30

  init(samples: [M]) {
    self.samples = samples
  }

  var filteredSamples: [M] {
    guard let daysBack = selectedRange.daysBack else {
      return downsampled(samples, limit: 150)
    }

    let cutoff = Calendar.current.date(byAdding: .day, value: -daysBack, to: .now)!
    let filtered = samples.filter { $0.date >= cutoff }
    return downsampled(filtered, limit: daysBack > 200 ? 150 : 60)
  }

  var averageValue: Double {
    guard !filteredSamples.isEmpty else { return 0 }
    return filteredSamples.map(\.value).reduce(0, +) / Double(filteredSamples.count)
  }

  var bestSample: M? {
    filteredSamples.max(by: { $0.value < $1.value })
  }

  var totalRunningDistance: Double? {
    guard let samples = filteredSamples as? [ChartDistanceModel] else { return nil }
    return samples.reduce(0) { $0 + $1.value }
  }

  private func downsampled(_ data: [M], limit: Int) -> [M] {
    guard data.count > limit else { return data }
    let step = Double(data.count) / Double(limit)
    return stride(from: 0.0, to: Double(data.count), by: step).map { data[Int($0)] }
  }
}
