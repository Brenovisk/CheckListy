//
//  ScrollableModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import Foundation
import SwiftUI

struct ScrollableModifier<TitleView: View>: ViewModifier {
    
    let titleView: TitleView
    @State private var showTitle = false
    
    func body(content: Content) -> some View {
        ScrollView {
            ZStack {
                content
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .padding(.horizontal, 16)
        .onPreferenceChange(ViewOffsetKey.self) { value in
            handleScrollValue(value)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if showTitle {
                    titleView
                }
            }
        }
    }
    
    private func handleScrollValue(_ value: ViewOffsetKey.Value) {
        withAnimation {
            showTitle = value < -30
        }
    }
}

extension View {
    func scrollable<TitleView: View>(@ViewBuilder title: () -> TitleView) -> some View {
        self.modifier(ScrollableModifier(titleView: title()))
    }
}
