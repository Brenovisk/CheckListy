//
//  GridModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/07/24.
//

import Foundation
import SwiftUI

struct GridModifier: ViewModifier {
    
    @Binding var isGrid: ListMode
    var columns: Int = 2
    
    var columnsGrid: Array<GridItem> = []
    var oneColumn: Array<GridItem> = [ GridItem(.flexible()) ]
    
    init(isGrid: Binding<ListMode>, columns: Int = 2) {
        self._isGrid = isGrid
        self.columnsGrid = (0..<columns).map { _ in GridItem(.flexible()) }
    }

    func body(content: Content) -> some View {
        LazyVGrid(columns: isGrid == .grid ? columnsGrid : oneColumn , spacing: 0) {
            content
        }
    }
    
}

extension View {
    
    func grid(enable: Binding<ListMode>, columns: Int = 2) -> some View {
        self.modifier(GridModifier(isGrid: enable, columns: columns))
    }
    
}
