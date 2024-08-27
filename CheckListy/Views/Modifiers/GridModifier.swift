//
//  GridModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/07/24.
//

import Foundation
import SwiftUI

struct GridModifier: ViewModifier {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Binding var isGrid: ListMode
    var columns: Int
    
    var columnsGrid: Array<GridItem> = []
    var columnsGridLandscape: Array<GridItem> = []
    var oneColumn: Array<GridItem> = [ GridItem(.flexible()) ]
    
    init(isGrid: Binding<ListMode>, columns: Int = 2) {
        self._isGrid = isGrid
        self.columns = columns
        self.columnsGrid = getColumnsGrid(columns)
        self.columnsGridLandscape = getColumnsGrid(2 * columns)
    }

    func body(content: Content) -> some View {
        LazyVGrid(columns: getColumns(), spacing: 0) {
            content
        }
    }
    
}

extension View {
    
    func grid(enable: Binding<ListMode> = Binding.constant(.grid), columns: Int = 2) -> some View {
        self.modifier(GridModifier(isGrid: enable, columns: columns))
    }
    
}

extension GridModifier {
    
    private func getColumnsGrid(_ columns: Int) -> [GridItem] {
        return (0..<columns).map { _ in GridItem(.flexible()) }
    }
    
    private func getColumns() -> Array<GridItem> {
        if verticalSizeClass != .regular {
            return columnsGridLandscape
        }
        
        if isGrid == .grid {
            return columnsGrid
        }
        
        return oneColumn
    }
    
}
