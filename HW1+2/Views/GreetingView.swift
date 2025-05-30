// GreetingView.swift
import SwiftUI

struct GreetingView: View {
    let name: String

    var body: some View {
        Text("Hi, \(name)!")
            .font(.headline)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("AccentColor1").opacity(0.3))
            )
            .foregroundColor(Color("TextColor"))
    }
}
