//
//  FilledButtonModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct FilledButtonModifier: ViewModifier {

    @Binding var isLoading: Bool
    var backgroundColor: Color
    var labelColor: Color

    init(
        isLoading: Binding<Bool>,
        backgroundColor: Color = Color.accentColor,
        labelColor: Color = Color.background
    ) {
        _isLoading = isLoading
        self.backgroundColor = backgroundColor
        self.labelColor = labelColor
    }

    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .tint(labelColor)
                    .frame(maxWidth: .infinity)
            } else {
                content
            }
        }
        .padding()
        .background(backgroundColor)
        .foregroundColor(labelColor)
        .cornerRadius(14)
        .font(.headline)
        .disabled(isLoading)
    }

}

extension View {

    func filledButton(
        isLoading: Binding<Bool>? = nil,
        backgroundColor: Color = Color.accentColor,
        labelColor: Color = Color.background
    ) -> some View {
        modifier(
            FilledButtonModifier(
                isLoading: isLoading ?? Binding.constant(false),
                backgroundColor: backgroundColor,
                labelColor: labelColor
            )
        )
    }

}
