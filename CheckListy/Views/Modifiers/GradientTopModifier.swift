//
//  GradientTopModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct GradientTopModifier: ViewModifier {
    @State private var height: CGFloat = 0
    var color: Color
    var finalHeight: CGFloat
    var delay: CGFloat = 0.1
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    VStack {
                        LinearGradient(
                            gradient: Gradient(colors: [color, Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(
                            width: .infinity,
                            height: min(height, geometry.size.height)
                        )
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.8).delay(delay)) {
                                height = finalHeight
                            }
                        }
                        .clipped()
                    }
                    .frame(height: geometry.size.height, alignment: .top)
                }
                .ignoresSafeArea(edges: .top)
            )
    }
}

extension View {
    
    func gradientTop(color: Color, height: CGFloat, delay: CGFloat = 0.1) -> some View {
        self.modifier(
            GradientTopModifier(
                color: color,
                finalHeight: height,
                delay: delay
            )
        )
    }
    
}
