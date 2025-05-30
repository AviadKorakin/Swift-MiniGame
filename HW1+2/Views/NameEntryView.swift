import SwiftUI

struct NameEntryView: View {
    @Binding var tempName: String
    var onCommit: () -> Void

    var body: some View {
        TextField("Enter your name", text: $tempName)
            .onSubmit { onCommit() }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("AccentColor1").opacity(0.2))
            )
            .foregroundColor(Color("TextColor"))
            .autocorrectionDisabled(true)
    }
}
