//
//  GradientTopModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct GradientTopModifier: ViewModifier {
    
    let color: Color
    let finalHeight: CGFloat

    @State private var height: Double = 0

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [color, Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height)
            .animation(
                Animation.easeInOut(duration: 1).delay(0.1),
                value: height
            )
            .onAppear {
                height = finalHeight
            }
            
            
            content
        }.ignoresSafeArea()
    }
    
}

extension View {
    
    func gradientTop(color: Color, height: CGFloat) -> some View {
        self.modifier(
            GradientTopModifier(
                color: color,
                finalHeight: height
            )
        )
    }
    
}
