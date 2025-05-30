import SwiftUI

struct ContentView: View {
    @StateObject private var vm = SideDeterminationVM()
    
    /// Portrait slice height as fraction of screen
    private let sliceHeightRatio: CGFloat = 0.5
    /// Portrait padding on earth edges
    private let sidePaddingPortrait: CGFloat = 8
    /// Fixed width for the center form
    private let formWidth: CGFloat = 180
    /// Horizontal margin between each slice and the form
    private let gapMarginPortrait: CGFloat = 20
    private let gapMarginLandscape: CGFloat = 40
    
    /// Triggers navigation into the game
    @State private var startGame = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let isLandscape = geo.size.width > geo.size.height
                let sidePadding = isLandscape ? 0 : sidePaddingPortrait
                let gapMargin = isLandscape ? gapMarginLandscape : gapMarginPortrait

                // Original computation
                let rawTotalWidth       = geo.size.width - 2 * sidePadding
                let totalAvailableWidth = max(rawTotalWidth, 0)           
                let centerGap           = formWidth + 2 * gapMargin
                let rawSlicesWidth      = totalAvailableWidth - centerGap
                let safeCombinedWidth   = max(rawSlicesWidth, 0)
                let safeHalfSlice       = safeCombinedWidth / 2

                // Portrait vs. landscape slice height
                let sliceHeight = isLandscape
                    ? geo.size.height
                    : geo.size.height * sliceHeightRatio

                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()

                    HStack(spacing: gapMargin) {
                        // Left half
                        Image(vm.earthImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: safeCombinedWidth, height: sliceHeight)
                            .clipped()
                            .frame(width: safeHalfSlice, height: sliceHeight, alignment: .leading)
                            .clipped()
                            .allowsHitTesting(false)

                        // Center form
                        VStack(spacing: 20) {
                            if !vm.hasName {
                                NameEntryView(
                                    tempName: $vm.tempName,
                                    onCommit: vm.saveName
                                )
                            } else {
                                GreetingView(name: vm.playerName)
                            }
                            StartSectionView(
                                side: vm.side,
                                isReady: vm.isReady,
                                startAction: { startGame = true }
                            )
                        }
                        .frame(width: formWidth)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("AccentColor2"))
                        )
                        .zIndex(1)

                        // Right half
                        Image(vm.earthImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: safeCombinedWidth, height: sliceHeight)
                            .clipped()
                            .frame(width: safeHalfSlice, height: sliceHeight, alignment: .trailing)
                            .clipped()
                            .allowsHitTesting(false)
                    }
                    .padding(.horizontal, sidePadding)
                    .frame(width: totalAvailableWidth)                       // now always ≥ 0
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .onAppear { vm.requestLocation() }
                }
                .navigationDestination(isPresented: $startGame) {
                    GameView(playerSide: vm.side)
                }
            }
            .ignoresSafeArea(edges: .horizontal)
        }
    }
}
#Preview("Default Light Preview") {
    ContentView()
}

#Preview("Dark Mode") {
    ContentView()
        .environment(\.colorScheme, .dark)
}
