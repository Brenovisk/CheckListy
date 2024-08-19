//
//  FilledButtonModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

struct FilledButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.background)
            .cornerRadius(14)
            .font(.headline)
    }
    
}

extension View {
    
    func filledButton() -> some View {
        self.modifier(FilledButtonModifier())
    }
    
}
