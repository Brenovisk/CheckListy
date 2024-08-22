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
    
    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView()
                    .tint(ColorsHelper.background.value)
                    .frame(maxWidth: .infinity)
            } else {
                content
            }
        }
        .padding()
        .background(Color.accentColor)
        .foregroundColor(.background)
        .cornerRadius(14)
        .font(.headline)
    }
    
}

extension View {
    
    func filledButton(isLoading: Binding<Bool>? = nil) -> some View {
        self.modifier(FilledButtonModifier( isLoading: isLoading ?? Binding.constant(false)))
    }
    
}
