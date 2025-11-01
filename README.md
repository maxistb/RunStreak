# 🏃‍♂️ RunStreak — Build Endurance Through Consistency

RunStreak is a beautifully designed SwiftUI app in the Neobrutalism Style.It helps runners visualize their progress, track VO₂max, distance, heart rate, and maintain running streaks — all powered by **HealthKit**.

![App Screenshot](Docs/preview.png)

---

## ✨ Features

📈 **Metrics Overview**
  - VO₂max, distance, and heart rate visualized with Swift Charts
  - Interactive charts with touch-to-inspect functionality
  - Detailed trend analysis and insights per metric

🔥 **Streak Tracking**
  - Track consecutive running days directly from HealthKit
  - Displays motivational messages based on your current streak
  - New record badge shown automatically when you break a streak milestone

🧭 **Metric Detail Views**
  - Filter data by 7 days, 30 days, 1 year, or all-time
  - Dynamic chart interpolation for smooth trend visualization
  - Data automatically adjusts between metric and imperial units

💥 **Widgets**
  - Neobrutalist home-screen widget displaying your streak, distance, and VO₂max
  - Supports iOS 18+ **tinted mode** for colorless rendering
  - Automatically updates when new HealthKit workouts are logged

⚙️ **HealthKit Integration**
  - Securely reads running workouts, VO₂max, and heart rate
  - Background updates keep widgets and charts in sync
  - Simulator-safe with realistic mock data

🧩 **Simulator Support**
  - Mock data generator simulating 10 days of runs
  - Gradually increasing VO₂max trend up to 62.9
  - Works seamlessly without needing HealthKit permissions

---

## 🧠 Architecture

RunStreak follows a clean SwiftUI MVVM pattern

---

## 🧰 Requirements

- **Xcode 16+**
- **iOS 18.0+**
- **Swift 5.10+**
- **HealthKit Entitlements Enabled**

To use HealthKit data:
1. Go to your **App Capabilities** → enable **HealthKit**
2. Add required read permissions in your **Info.plist**

---

🚀 Getting Started
	1. Clone the repository:
  ```xml
  git clone https://github.com/maxistb/RunStreak.git
  cd RunStreak
  ```
  2. Open the project:
  ```xml
  open RunStreak.xcodeproj
  ```
  3. Authorize HealthKit when prompted.

--- 

🧪 Mock Data Mode

When running in the iOS Simulator, HealthKit calls are replaced by mock data generators.
```xml
  #if targetEnvironment(simulator)
  extension HealthKitManager {
    func fetchRunningWorkouts() async throws -> [RunDay] { ... }
  }
  #endif
```

The simulator returns:
	•	🏃 10 days of simulated runs
	•	📈 Gradual VO₂max increase from 52 → 62.9
	•	💓 Realistic heart rates (135–165 bpm)
	•	🕒 Continuous streak for chart testing

This allows you to fully test charts, detail screens, and widgets without any HealthKit permissions.

---

💾 Widgets & Background Updates

RunStreak includes a WidgetKit extension that updates automatically via HealthKit background delivery.

Add this to your Info.plist:
```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
  <string>com.runstreak.refresh</string>
</array>
```

Register your task on startup:
```xml
BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.runstreak.refresh", using: nil) { task in
    await HealthKitManager.shared.refreshAndSaveWidgetData()
    task.setTaskCompleted(success: true)
}
```

---

💡 Contributing

Contributions are welcome!
	1. Fork the repository
	2. Create a feature branch

  ```xml
  git checkout -b feature/improve-vo2max-logic
```
  3. Commit your changes
	4. Submit a pull request 🚀

---

🛡️ License

This project is licensed under the MIT License.

Copyright 2025 Maximillian Stabe.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
