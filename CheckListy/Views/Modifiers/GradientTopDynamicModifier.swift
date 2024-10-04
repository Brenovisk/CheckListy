//
//  GradientTopDynamicModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/10/24.
//

import Foundation
import SwiftUI

struct GradientTopDynamicModifier: ViewModifier {

    @State private var heightLocal: CGFloat = 0

    var height: CGFloat = 220
    var color: Color
    var scrollOffset: Binding<CGFloat>

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor, Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: scrollOffset.wrappedValue >= 0 ? scrollOffset.wrappedValue + heightLocal : 0)
            .edgesIgnoringSafeArea(.top)

            content
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.1)) {
                heightLocal = height
            }
        }
    }

}

extension View {

    func gradientTopDynamic(color: Color, height: CGFloat, scrollOffset: Binding<CGFloat>) -> some View {
        modifier(
            GradientTopDynamicModifier(
                height: height,
                color: color,
                scrollOffset: scrollOffset
            )
        )
    }

}
