//
//  SlideOnAppearModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 26/08/24.
//

import Foundation
import SwiftUI

struct SlideOnAppearModifier: ViewModifier {
    
    var delay: Double
    var animation: Animation
    var direction: SlideDirection

    @State private var isVisible: Bool = false

    func body(content: Content) -> some View {
        content
            .offset(x: isVisible ? 0 : offsetX, y: isVisible ? 0 : offsetY)
            .animation(animation.delay(delay), value: isVisible)
            .onAppear {
                isVisible = true
            }
    }

    private var offsetX: CGFloat {
        switch direction {
        case .fromLeft: return -UIScreen.main.bounds.width
        case .fromRight: return UIScreen.main.bounds.width
        case .fromTop: return 0
        case .fromBottom: return 0
        }
    }

    private var offsetY: CGFloat {
        switch direction {
        case .fromTop: return -UIScreen.main.bounds.height
        case .fromBottom: return UIScreen.main.bounds.height
        case .fromLeft, .fromRight: return 0
        }
    }
}

enum SlideDirection {
    case fromLeft, fromRight, fromTop, fromBottom
}

extension View {
    func slideOnAppear(delay: Double = 0, animation: Animation = .easeInOut(duration: 0.5), direction: SlideDirection = .fromBottom) -> some View {
        self.modifier(SlideOnAppearModifier(delay: delay, animation: animation, direction: direction))
    }
}
