//
//  AnimatedBackgroundModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct AnimatedBackgroundModifier: ViewModifier, KeyboardReadable {
    @State private var offset = 0.0
    @State private var opacity = 0.0
    let animationDuration: Double = 40.0

    func body(content: Content) -> some View {
        ZStack {
            VStack {
                ImagesHelper.coloredShapesVector.image
                    .resizable()
                    .scaledToFill()
                ImagesHelper.coloredShapesVector.image
                    .resizable()
                    .scaledToFill()
            }
            .frame(height: UIScreen.main.bounds.height)
            .offset(y: offset)
            .transition(.opacity)
            .onAppear {
                startAnimation()
            }

            content
        }
    }

    private func startAnimation() {
        opacity = 1

        withAnimation(
            Animation.linear(duration: animationDuration)
                .repeatForever(autoreverses: false)
        ) {
            offset = -UIScreen.main.bounds.height
        }
    }
}

extension View {
    func animatedBackground() -> some View {
        modifier(AnimatedBackgroundModifier())
    }
}
