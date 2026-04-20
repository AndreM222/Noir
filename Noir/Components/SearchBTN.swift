//
//  User.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/1/26.
//

import SwiftUI

struct SearchBTN: View {
    var size: CGFloat = 40
    var backgroundColor: Color = .gray.opacity(0.2)
    var iconColor: Color = .primary

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .padding(size * 0.22)
                .foregroundStyle(iconColor)
        }
        .frame(width: size, height: size)
        .overlay(
            Circle()
                .stroke(.white.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
        .accessibilityLabel("User avatar")
    }
}

#Preview {
    VStack {
        SearchBTN(size: 72, backgroundColor: .blue.opacity(0.18), iconColor: .blue)
    }
    .padding()
}
