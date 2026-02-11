//
//  SplashView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import Foundation
import SwiftUI

struct SplashView: View {

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var isAnimating = false

    var expand: Bool

    var body: some View {
        VStack {
            ImagesHelper.logo.image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    startPulsingAnimation()
                }
                .onChange(of: expand) {
                    if expand {
                        startExpandAnimation()
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorsHelper.background.value)
        .ignoresSafeArea()
    }

    private func startPulsingAnimation() {
        isAnimating = true
        withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            scale = 1.3
            opacity = 0.7
        }
    }

    private func startExpandAnimation() {
        isAnimating = false
        withAnimation(Animation.easeInOut(duration: 0.6)) {
            scale = 100.0
            opacity = 0.0
        }
    }

}

#Preview {
    SplashView(expand: false)
}
