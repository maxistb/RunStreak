//
//  HomeView.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftData
import SwiftUI

struct HomeScreen: View {
  @State private var showAllRuns = false
  @State private var runs: [RunDay] = []

  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
          header
            .padding(.horizontal, 16)

          statisticBadges

          StreakBlock(streakCount: calculateStreak(from: runs))
            .padding(.horizontal, 16)

          todayRunBadge
            .padding(.horizontal, 16)

          DonationCards()

          StatsOverview(runs: runs)
            .padding(.horizontal, 16)

          allRunButton
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 24)
        .background(AppColor.background)
        .cornerRadius(20)
      }
      .background(AppColor.background.ignoresSafeArea())
      .navigationDestination(isPresented: $showAllRuns) {
        AllRunsScreen(runs: runs)
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
          color: AppColor.accentBlue
        ) {
          NavigationLink(destination: Text("")) { EmptyView() }
        }
        .padding(.leading, 16)

        InsightPreviewButton(
          title: "Heart Rate",
          value: "\(Int(avgHeartRateLast7Days)) bpm",
          icon: "heart.fill",
          color: AppColor.accentPink
        ) {
          NavigationLink(destination: Text("")) { EmptyView() }
        }

        InsightPreviewButton(
          title: "VO₂ Max",
          value: "\(String(format: "%.1f", avgVo2MaxLast7Days)) ml/kg/min",
          icon: "lungs.fill",
          color: AppColor.accentMint
        ) {
          NavigationLink(destination: Text("")) { EmptyView() }
        }
        .padding(.trailing, 16)
      }
    }
  }

  private var allRunButton: some View {
    Button {
      showAllRuns = true
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
}
