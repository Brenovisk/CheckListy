//
//  ContainerRelativeFrameHorizontalModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/07/24.
//

import Foundation
import SwiftUI

struct ContainerRelativeFrameHorizontalModifier: ViewModifier {
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var regularCount: Int
    var compactCount: Int
    var spacing: CGFloat

    func body(content: Content) -> some View {
        content.containerRelativeFrame(
            .horizontal,
            count: verticalSizeClass == .regular ? regularCount : compactCount,
            spacing: spacing
        )
    }
}

extension View {
    func containerRelativeHorizontal(
        _ regularCount: Int = 2,
        _ compactCount: Int = 4,
        _ spacing: CGFloat = 16
    ) -> some View {
        modifier(ContainerRelativeFrameHorizontalModifier(
            regularCount: regularCount,
            compactCount: compactCount,
            spacing: spacing
        ))
    }
}
