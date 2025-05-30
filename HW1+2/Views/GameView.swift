//  GameView.swift
//  HW1+2
//
//  Created by Aviad on 25/05/2025.

import SwiftUI

struct GameView: View {
    @StateObject private var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    @State private var countdown = 5
    @State private var navigateToResults = false
    private let playerSide: String
    private let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(playerSide: String) {
        self.playerSide = playerSide
        _vm = StateObject(wrappedValue: GameViewModel(playerSide: playerSide))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer().frame(height: 12)
                    Text("Round \(vm.round)/\(vm.totalRounds)")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))

                    HStack(alignment: .bottom, spacing: 24) {
                        VStack(spacing: 8) {
                            Text("East").font(.caption).foregroundColor(Color("AccentColor1"))
                            cardView(vm.currentPair?.east, isEast: true)
                            Text("Score: \(vm.scoreEast)").font(.subheadline).foregroundColor(Color("AccentColor1"))
                        }
                        VStack(spacing: 8) {
                            Text("West").font(.caption).foregroundColor(Color.red)
                            cardView(vm.currentPair?.west, isEast: false)
                            Text("Score: \(vm.scoreWest)").font(.subheadline).foregroundColor(Color.red)
                        }
                    }
                    .frame(height: 240)

                    HStack {
                        Text(vm.gameOver ? "Moving to results in \(countdown)s" : "Next flip in \(countdown)s")
                            .font(.subheadline)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Capsule().fill(Color("AccentColor2").opacity(0.3)))
                            .foregroundColor(Color("TextColor"))
                        Spacer()
                    }
                    .padding(.horizontal)

                    Button("Quit") { dismiss() }
                        .font(.subheadline).bold()
                        .padding(.horizontal, 20).padding(.vertical, 6)
                        .background(Capsule().fill(Color.red))
                        .foregroundColor(.white)
                    Spacer().frame(height: 12)
                }
                .padding(.horizontal)
                .navigationBarBackButtonHidden(true)
                .onChange(of: scenePhase, initial: false) { _, newPhase in
                    switch newPhase {
                    case .active:   vm.resume()
                    case .inactive, .background: vm.pause()
                    @unknown default: break
                    }
                }
                .onAppear {
                        vm.start()
                        countdown = 5
                    }
                .onChange(of: scenePhase) { _,newPhase in
                        switch newPhase {
                        case .active:
                            vm.resume()
                        case .inactive, .background:
                            vm.pause()
                        @unknown default: break
                        }
                    }
                .onChange(of: vm.round) { _, newRound in
                        if newRound <= vm.totalRounds {
                            countdown = 5
                        }
                    }
                .onReceive(countdownTimer) { _ in
                    guard scenePhase == .active else { return }
                    if vm.gameOver {
                        if countdown > 0 { countdown -= 1 } else { navigateToResults = true }
                    } else if countdown > 0 { countdown -= 1 }
                }
                .onChange(of: vm.gameOver, initial: false) { _, over in if over { countdown = 5 } }
                .navigationDestination(isPresented: $navigateToResults) {
                    ResultsView(winner: vm.winner ?? "House" , playerSide: playerSide)
                }
            }
        }
    }

    @ViewBuilder
    private func cardView(_ imageName: String?, isEast: Bool) -> some View {
        if vm.isRevealed, let name = imageName {
            Image(name).resizable().scaledToFit().cornerRadius(12).shadow(radius: 6)
        } else {
            Image(isEast ? vm.eastBackImageName : vm.westBackImageName)
                .resizable().scaledToFit().cornerRadius(12).shadow(radius: 6)
        }
    }
    
}
#Preview("GameView Light Preview") {
    GameView(playerSide: "East")
}

#Preview("GameView Dark Mode") {
    GameView(playerSide: "East")
        .environment(\.colorScheme, .dark)
}
