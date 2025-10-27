//
//  HomeView.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftData
import SwiftUI

struct HomeScreen: View {
  enum Destination: Hashable {
    case vo2Max
    case distance
    case heartRate
    case allRuns
  }

  @State private var runs: [RunDay] = []
  @State private var destination: Destination?

  private var groupedDistance: [ChartDistanceModel] {
    groupRunsByDay(runs, dateKey: \.date, valueKey: { $0.distanceInMeters })
      .map { .init(date: $0.date, value: $0.average / 1000) }
  }

  private var groupedHeartRate: [ChartHeartRateModel] {
    groupRunsByDay(runs, dateKey: \.date, valueKey: { $0.avgHeartRate })
      .map { .init(date: $0.date, value: $0.average) }
  }

  private var groupedVo2Max: [ChartVo2MaxModel] {
    groupRunsByDay(runs, dateKey: \.date, valueKey: { $0.vo2Max })
      .map { .init(date: $0.date, value: $0.average) }
  }

  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
          header
            .padding(.horizontal, 16)

          statisticBadges

          StreakCard(streakCount: calculateStreak(from: runs))
            .padding(.horizontal, 16)

          todayRunBadge
            .padding(.horizontal, 16)

          allRunButton
            .padding(.horizontal, 16)

          DonationCards()

          StatsOverview(runs: runs)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 24)
        .background(AppColor.background)
        .cornerRadius(20)
      }
      .background(AppColor.background.ignoresSafeArea())
      .navigationDestination(item: $destination) { destination in
        switch destination {
          case .vo2Max:
            MetricDetailView<ChartVo2MaxModel>(
              title: "VO₂max",
              unit: "ml/kg/min",
              accentColor: AppColor.accentMint,
              footerText: "Improving VO₂max boosts endurance and stamina 💪",
              samples: groupedVo2Max
            )

          case .distance:
            MetricDetailView<ChartDistanceModel>(
              title: "Distance",
              unit: "km",
              accentColor: AppColor.accentBlue,
              footerText: "Keep going — consistency builds endurance 🏃‍♂️💪",
              samples: groupedDistance
            )

          case .heartRate:
            MetricDetailView<ChartHeartRateModel>(
              title: "Heart Rate",
              unit: "bpm",
              accentColor: AppColor.accentPink,
              footerText: "Lower resting heart rate = better cardiovascular health ❤️",
              samples: groupedHeartRate
            )

          case .allRuns:
            AllRunsScreen(runs: runs)
        }
      }
      .task {
        try? await HealthKitManager.shared.requestAuthorization()
        runs = (try? await HealthKitManager.shared.fetchRunningWorkouts()) ?? []
      }
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Welcome Back, Maxi 👋")
        .font(.system(size: 26, weight: .bold, design: .rounded))
        .foregroundColor(AppColor.textPrimary)

      Text("Keep the streak alive and run happy!")
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .foregroundColor(AppColor.textSecondary)
    }
  }

  @ViewBuilder
  private var todayRunBadge: some View {
    let todayDistanceKm: Double = {
      let meters = runs
        .filter { Calendar.current.isDateInToday($0.date) }
        .reduce(0.0) { $0 + $1.distanceInMeters }
      return meters / 1000.0
    }()

    if todayDistanceKm > 0 {
      HStack {
        Text("Today’s Run Complete ✅")
          .font(.system(size: 18, weight: .bold, design: .rounded))
          .foregroundColor(.black)
        Spacer()
        Text("\(String(format: "%.1f km", todayDistanceKm))")
          .font(.system(size: 18, weight: .bold, design: .rounded))
          .foregroundColor(.black)
      }
      .padding()
      .background(AppColor.accentMint)
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.black, lineWidth: 2)
      )
      .cornerRadius(20)
    }
  }

  private var statisticBadges: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        InsightPreviewButton(
          title: "Distance",
          value: "\(String(format: "%.1f km", totalDistanceLast7Days))",
          icon: "figure.run",
          color: AppColor.accentBlue,
          hasTrailingArrow: true
        ) {
          destination = .distance
        }
        .padding(.leading, 16)

        InsightPreviewButton(
          title: "Heart Rate",
          value: "\(Int(avgHeartRateLast7Days)) bpm",
          icon: "heart.fill",
          color: AppColor.accentPink,
          hasTrailingArrow: true
        ) {
          destination = .heartRate
        }

        InsightPreviewButton(
          title: "VO₂ Max",
          value: "\(String(format: "%.1f", avgVo2MaxLast7Days)) ml/kg/min",
          icon: "lungs.fill",
          color: AppColor.accentMint,
          hasTrailingArrow: true
        ) {
          destination = .vo2Max
        }
        .padding(.trailing, 16)
      }
    }
  }

  private var allRunButton: some View {
    Button {
      destination = .allRuns
    } label: {
      Text("View All Runs")
        .font(.system(size: 17, weight: .bold, design: .rounded))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppColor.accentLilac)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.black, lineWidth: 2)
        )
        .cornerRadius(20)
    }
    .buttonStyle(PlainButtonStyle())
    .pressedEffect()
  }

  private func calculateStreak(from runs: [RunDay]) -> Int {
    let sortedDays = Array(Set(runs.map { Calendar.current.startOfDay(for: $0.date) })).sorted(by: >)
    guard let mostRecent = sortedDays.first else { return 0 }

    var streak = 1
    var previousDay = mostRecent
    for day in sortedDays.dropFirst() {
      let daysBetween = Calendar.current.dateComponents([.day], from: day, to: previousDay).day ?? 0
      if daysBetween == 1 {
        streak += 1
        previousDay = day
      } else { break }
    }
    return streak
  }

  private var totalDistanceLast7Days: Double {
    let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
    let recentRuns = runs.filter { $0.date >= oneWeekAgo }
    return recentRuns.reduce(0) { $0 + $1.distanceInMeters } / 1000
  }

  private var avgHeartRateLast7Days: Double {
    let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
    let recent = runs.filter { $0.date >= oneWeekAgo && $0.avgHeartRate != nil }
    guard !recent.isEmpty else { return 0 }
    return recent.reduce(0) { $0 + ($1.avgHeartRate ?? 0) } / Double(recent.count)
  }

  private var avgVo2MaxLast7Days: Double {
    let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
    let recent = runs.filter { $0.date >= oneWeekAgo && $0.vo2Max != nil }
    guard !recent.isEmpty else { return 0 }
    return recent.reduce(0) { $0 + ($1.vo2Max ?? 0) } / Double(recent.count)
  }

  /// Groups runs by day and averages a numeric metric value (e.g., distance, heart rate, vo2max)
  func groupRunsByDay<T>(
    _ runs: [T],
    dateKey: (T) -> Date,
    valueKey: (T) -> Double?
  ) -> [(date: Date, average: Double)] {
    let calendar = Calendar.current

    let grouped = Dictionary(grouping: runs, by: { calendar.startOfDay(for: dateKey($0)) })

    return grouped.compactMap { date, items in
      let validValues = items.compactMap(valueKey).filter { $0.isFinite && $0 > 0 }

      guard !validValues.isEmpty else { return nil }

      let avg = validValues.reduce(0, +) / Double(validValues.count)
      guard avg.isFinite else { return nil }

      return (date, avg)
    }
    .sorted { $0.date < $1.date }
  }
}
