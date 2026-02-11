//
//  ScrollableModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import Foundation
import SwiftUI

struct ScrollableModifier<TitleView: View>: ViewModifier {

    var padding: Double = 16
    let titleView: TitleView
    var scrollOffset: Binding<CGFloat>?

    @State private var showTitle = false

    func body(content: Content) -> some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                content

                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .padding(.horizontal, padding)
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

            if let scrollOffset = scrollOffset {
                scrollOffset.wrappedValue = value
                return
            }
        }
    }

}

extension View {

    func scrollable<TitleView: View>(
        padding: Double = 16,
        scrollOffset: Binding<CGFloat>? = nil,
        @ViewBuilder title: () -> TitleView
    ) -> some View {
        modifier(
            ScrollableModifier(
                padding: padding,
                titleView: title(),
                scrollOffset: scrollOffset
            )
        )
    }

}
