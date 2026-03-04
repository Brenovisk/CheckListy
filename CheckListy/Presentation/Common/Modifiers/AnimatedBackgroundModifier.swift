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
    var blackVectors: Bool

    func body(content: Content) -> some View {
        ZStack {
            VStack {
                if blackVectors {
                    ForEach(0 ..< 3) { _ in
                        ImagesHelper.coloredShapesBlackVector.image
                            .resizable()
                            .scaledToFill()
                    }
                } else {
                    ForEach(0 ..< 1) { _ in
                        ImagesHelper.coloredShapesVector.image
                            .resizable()
                            .scaledToFill()
                    }
                }
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

    func animatedBackground(_ blackVectors: Bool = false) -> some View {
        modifier(AnimatedBackgroundModifier(blackVectors: blackVectors))
    }

}
