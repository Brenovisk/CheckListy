//
//  CollapseModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 18/07/24.
//

import Foundation
import SwiftUI

struct CollapseModifier: ViewModifier {
    
    var isCollapsed: Bool

    func body(content: Content) -> some View {
        if isCollapsed {
            AnyView(EmptyView())
        } else {
            AnyView(content)
        }
    }
    
}

extension View {
    
    func collapse(isCollapsed: Bool) -> some View {
        self.modifier(CollapseModifier(isCollapsed: isCollapsed))
    }
    
}
