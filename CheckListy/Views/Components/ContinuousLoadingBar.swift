//
//  ContinuousLoadingBar.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation

import SwiftUI

struct ContinuousLoadingBar: View {
    @State private var isAnimating = false

    let heightBar = 4.0
    let widthBar = 100.0
    let coloBar: Color = .accentColor

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: heightBar)

            RoundedRectangle(cornerRadius: 10)
                .fill(coloBar)
                .frame(width: widthBar, height: heightBar)
                .offset(x: isAnimating ? UIScreen.main.bounds.width - widthBar : -widthBar)
                .animation(
                    Animation.linear(duration: 1.0)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation {
                self.isAnimating = true
            }
        }
    }
}

#Preview {
    ContinuousLoadingBar()
}
