//
//  ScrollHorizontalModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/07/24.
//

import Foundation
import SwiftUI

struct ScrollHorizontalModifier: ViewModifier {

    var padding: CGFloat

    func body(content: Content) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                content
            }
        }
        .contentMargins(.horizontal, padding, for: .scrollContent)
    }

}

extension View {

    func scrollHorizontal(padding: CGFloat = 8) -> some View {
        modifier(ScrollHorizontalModifier(padding: padding))
    }

}
