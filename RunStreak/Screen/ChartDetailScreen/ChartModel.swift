//
//  DailyDistance.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 27.10.25.
//

import Foundation

protocol ChartMetric: Identifiable {
  var id: UUID { get }
  var date: Date { get }
  var value: Double { get }

  init(date: Date, value: Double)
}

struct ChartDistanceModel: ChartMetric {
  let id = UUID()
  let date: Date
  let value: Double
  var km: Double { value }
}

struct ChartVo2MaxModel: ChartMetric {
  let id = UUID()
  let date: Date
  let value: Double
}

struct ChartHeartRateModel: ChartMetric {
  let id = UUID()
  let date: Date
  let value: Double
}
