//
//  HomeView.swift
//  RunStreak
//
//  Created by Maximillian Stabe on 07.10.25.
//

import SwiftData
import SwiftUI

import SwiftUI

struct HomeScreen: View {
  enum Destination: Hashable {
    case vo2Max, distance, heartRate, allRuns
  }

  @Environment(\.locale) var locale
  @State private var destination: Destination?
  @State private var viewModel = HomeScreenVM()

  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 24) {
          header
          statisticBadges
            .padding(.horizontal, -16)

          StreakCard(streakCount: viewModel.streakCount)
          todayRunBadge
          allRunButton
          DonationCards()
            .padding(.horizontal, -16)
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
      }
      .background(AppColor.background.ignoresSafeArea())
      .navigationDestination(item: $destination) { destinationView(for: $0) }
      .task {
        await viewModel.loadRuns()
        HealthKitManager.shared.startWorkoutObserver()
      }
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("\(Date().formatted(date: .long, time: .omitted)) 👋")
        .font(.system(size: 26, weight: .bold, design: .rounded))
      Text("Keep the streak alive and run happy!")
        .font(.system(size: 16, weight: .medium, design: .rounded))
        .foregroundColor(AppColor.textSecondary)
    }
  }

  private var statisticBadges: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      EqualHeightHStack {
        InsightPreviewButton(
          title: "Distance",
          subtitle: "(last 7 days)",
          value: viewModel.totalDistanceLast7Days(locale: locale),
          icon: "figure.run",
          color: AppColor.accentBlue,
          hasTrailingArrow: true
        ) { destination = .distance }

        InsightPreviewButton(
          title: "Heart Rate",
          subtitle: "(last 7 days)",
          value: "\(Int(viewModel.avgHeartRateLast7Days)) bpm",
          icon: "heart.fill",
          color: AppColor.accentPink,
          hasTrailingArrow: true
        ) { destination = .heartRate }

        InsightPreviewButton(
          title: "VO₂ Max",
          subtitle: "(last 7 days)",
          value: "\(String(format: "%.1f", viewModel.avgVo2MaxLast7Days))",
          icon: "lungs.fill",
          color: AppColor.accentMint,
          hasTrailingArrow: true
        ) { destination = .vo2Max }
      }
      .padding(.horizontal, 16)
    }
  }

  @ViewBuilder
  private var todayRunBadge: some View {
    if viewModel.hasCompletedTodayRun {
      TodayRunCard(distanceString: viewModel.todayDistanceString)
    }
  }

  private var allRunButton: some View {
    Button { destination = .allRuns } label: {
      Text("View All Runs")
        .font(.system(size: 17, weight: .bold, design: .rounded))
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .padding()
    }
    .buttonStyle(
      NeobrutalistButtonStyle(
        cornerRadius: 20,
        shadowOffset: 4,
        borderColor: .black,
        backgroundColor: AppColor.accentLilac
      )
    )
  }

  @ViewBuilder
  private func destinationView(for destination: Destination?) -> some View {
    switch destination {
      case .vo2Max:
        MetricDetailView<ChartVo2MaxModel>(
          title: "VO₂max",
          unit: .vo2Max,
          accentColor: AppColor.accentMint,
          footerText: "Improving VO₂max boosts endurance and stamina 💪",
          samples: viewModel.groupedVo2Max
        )
      case .distance:
        MetricDetailView<ChartDistanceModel>(
          title: "Distance",
          unit: .km,
          accentColor: AppColor.accentBlue,
          footerText: "Keep going — consistency builds endurance 🏃‍♂️💪",
          samples: viewModel.groupedDistance
        )
      case .heartRate:
        MetricDetailView<ChartHeartRateModel>(
          title: "Heart Rate",
          unit: .bpm,
          accentColor: AppColor.accentPink,
          footerText: "Lower resting heart rate = better cardiovascular health ❤️",
          samples: viewModel.groupedHeartRate
        )
      case .allRuns:
        AllRunsScreen(runs: viewModel.runs)
      case .none:
        EmptyView()
    }
  }
}
