//
//  AnimatedBackgroundModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct AnimatedBackgroundModifier: ViewModifier, KeyboardReadable {

    @State private var animate = false
    var blackVectors: Bool

    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(animate ? 1 : 0.8)
            .onAppear {
                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }

            content
        }
    }

}

extension View {

    func animatedBackground(_ blackVectors: Bool = false) -> some View {
        modifier(AnimatedBackgroundModifier(blackVectors: blackVectors))
    }

}
