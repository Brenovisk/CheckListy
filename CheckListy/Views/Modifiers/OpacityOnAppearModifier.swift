//
//  OpacityOnAppearModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 26/08/24.
//

import Foundation
import SwiftUI

struct OpacityOnAppearModifier: ViewModifier {
    var delay: Double
    var duration: Double

    @State private var isVisible: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(.easeInOut(duration: duration).delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }
}

extension View {
    func opacityOnAppear(delay: Double = 0, duration: Double = 0.5) -> some View {
        modifier(OpacityOnAppearModifier(delay: delay, duration: duration))
    }
}
