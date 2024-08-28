//
//  ScaleOnAppearModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 26/08/24.
//

import Foundation
import SwiftUI

struct ScaleOnAppearModifier: ViewModifier {
    var isActive: Bool
    var animation: Animation
    var scaleEffect: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 0 : 1)
            .animation(animation, value: isActive)
            .transition(.scale)
    }
}

extension View {
    func scaleOnAppear(isActive: Bool, scaleEffect: CGFloat = 1.0, animation: Animation = .spring()) -> some View {
        modifier(ScaleOnAppearModifier(isActive: isActive, animation: animation, scaleEffect: scaleEffect))
    }
}
