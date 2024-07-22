//
//  RoundedBackgroundTextFieldStyle.swift
//  CheckListy
//
//  Created by Breno Lucas on 16/07/24.
//

import Foundation
import SwiftUI

struct RoundedBackgroundTextFieldStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10) // Borda arredondada padrão da Apple
            .frame(height: 44) 
    }
    
}

extension View {
    
    func roundedBackgroundTextField() -> some View {
        self.modifier(RoundedBackgroundTextFieldStyle())
        
    }
}
