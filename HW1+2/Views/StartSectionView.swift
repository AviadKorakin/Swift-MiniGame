import SwiftUI

struct StartSectionView: View {
    let side: String
    let isReady: Bool
    let startAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Side indicator
            Text("You’re on the \(side) side")
                .font(.subheadline)
                .frame(maxWidth: .infinity, minHeight: 30)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color("AccentColor1").opacity(0.4))
                )
                .foregroundColor(Color("TextColor"))

            // Start button
            Button(action: startAction) {
                Text("Start")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .font(.headline)
            .foregroundColor(Color("BackgroundColor"))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isReady ? Color("TextColor") : Color.gray)
            )
            .foregroundColor(.white)
            .disabled(!isReady)
        }
    }
}
