//
//  ReadME.md
//  HW1+2
//
//  Created by Aviad on 30/05/2025.
//

# 🗺️ Side Determination & Card Flip Game 🃏

## 📖 Overview

This is a SwiftUI-based iOS app that determines which side of the world you’re on (East or West) based on your geographic location, then lets you play a simple card-flip game against the “House.” The game runs for 10 rounds, automatically flipping cards every few seconds, tracking scores, and showing a results screen at the end.

## ⭐ Features

* 🌍 **Location-based Side Selection**: Determines “East” or “West” side based on latitude.
* 🙋‍♂️ **Name Entry & Greeting**: Prompt for player name and persist it using `@AppStorage`.
* 🃏 **Automated Card Game**: 10 rounds of card flips, scores tracked for East vs West.
* ⏱️ **Timed Rounds**: Cards reveal for 3 seconds, then auto-advance every 5 seconds.
* 📱 **Responsive UI**: Adapts layout for portrait/landscape, including dynamic Earth image slices and material backgrounds.
* 🏆 **Result Screen**: Displays winner with custom icons and a “Home” button to restart.

## 🛠️ Requirements

* Xcode 15 or later
* iOS 16.0+
* Swift 5.8+

## 🚀 Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/AviadKorakin/Swift-MiniGame.git
   ```
2. Open the project in Xcode:

   ```bash
   cd your-repo-name
   open SideDeterminationGame.xcodeproj
   ```
3. Run the app on a simulator or device.

## 🎮 Usage

1. On launch, enter your name and grant location permission.
2. The app will choose East or West side and show a greeting.
3. Tap **Start** to begin the 10-round card flip game.
4. Watch cards auto-flip and scores update.
5. After 10 rounds, view the results and tap **Home** to play again.

## 📁 Project Structure

```
├── ContentView.swift         // Main entry: side determination UI
├── SideDeterminationVM.swift // ViewModel: location & side logic
├── GameView.swift            // Card game UI & timer logic
├── GameViewModel.swift       // Card game state & scheduling
├── GreetingView.swift        // Displays “Hi, <Name>!”
├── NameEntryView.swift       // TextField for name input
├── StartSectionView.swift    // Side indicator & Start button
├── ResultsView.swift         // Game Over screen with winner info
├── LocationManager.swift     // CLLocation wrapper
├── Assets.xcassets           // Images: earth slices, card backs, cards , theme colors
```

## 🎨 Customization

* **Total Rounds**: Change `totalRounds` in `GameViewModel`.
* **Reveal & Delay Times**: Adjust the `3`-second reveal and `5`-second delay values in `GameViewModel`.
* **UI Colors & Materials**: Tweak `Assets.xcassets` color sets or replace `ultraThinMaterial` backgrounds.

## 🤝 Contributing

Contributions are welcome! Please open issues and submit pull requests for bug fixes or enhancements.

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
