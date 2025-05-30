import SwiftUI

struct ResultsView: View {
    let winner: String
    let playerSide: String
    @Environment(\.dismiss) private var dismiss

    // The height we designed our card for
    private let designCardHeight: CGFloat = 400

    var body: some View {
        GeometryReader { geo in
            let isLandscape      = geo.size.width > geo.size.height
            let cardWidth        = isLandscape
                ? geo.size.width * 0.7
                : geo.size.width * 0.9
            let availableHeight  = min(cardWidth, geo.size.height * 0.8)
            let scale            = min(1, availableHeight / designCardHeight)

            // Full-screen background
            Color("BackgroundColor")
                .ignoresSafeArea()
                // Overlay the fixed-size card, centered
                .overlay(
                    VStack(spacing: isLandscape ? 20 : 24) {
                        // Icon
                        ResultIcon(
                            winner:     winner,
                            playerSide: playerSide,
                            cardWidth:  cardWidth
                        )

                        // Title
                        Text("Game Over")
                            .font(isLandscape ? .largeTitle : .largeTitle)
                            .bold()
                            .foregroundColor(Color("TextColor"))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        // Subtitle
                        Text(winner == playerSide ? "You won" : "You lost")
                            .font(isLandscape ? .title2 : .title2)
                            .foregroundColor(
                                winner == "House" ? .gray : Color("AccentColor1")
                            )
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        // Home Button
                        Button { dismiss() } label: {
                            Label("Home", systemImage: "house.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 32)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("AccentColor1"))
                                )
                        }
                    }
                    .frame(width: cardWidth, height: designCardHeight)
                    .background(.ultraThinMaterial, in:
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .shadow(color: .black.opacity(0.2),
                            radius: 10, x: 0, y: 5)
                    .scaleEffect(scale),
                    alignment: .center
                )
        }
    }
}

struct ResultIcon: View {
    let winner: String
    let playerSide: String
    let cardWidth: CGFloat

    private var iconName: String {
        if winner == "House"    { return "flag.fill" }
        if winner == playerSide { return "trophy.fill" }
        return "xmark.octagon.fill"
    }

    private var iconColor: Color {
        if winner == "House"    { return .gray }
        if winner == playerSide { return Color("AccentColor1") }
        return .red
    }

    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(
                width:  cardWidth / 3,
                height: cardWidth / 3
            )
            .foregroundColor(iconColor)
    }
}
#Preview("ResultsView Light") {
    ResultsView(winner: "Player", playerSide: "East")
}

#Preview("ResultsView Dark") {
    ResultsView(winner: "House", playerSide: "East")
        .environment(\.colorScheme, .dark)
}
