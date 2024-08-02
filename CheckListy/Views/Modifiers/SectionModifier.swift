//
//  SectionModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct SectionModifier: ViewModifier {
    
    var padding: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .cornerRadius(12)
    }
    
}

extension View {
    
    func section(padding: CGFloat = 16) -> some View {
        self.modifier(SectionModifier(padding: padding))
    }
    
}
