//
//  OutlineButtonModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/03/26.
//

import Foundation
import SwiftUI

struct OutlineButtonModifier: ViewModifier {

    var labelColor: Color

    init(labelColor: Color = Color.background) {
        self.labelColor = labelColor
    }

    func body(content: Content) -> some View {
        content
        .padding()
        .background(.clear)
        .foregroundColor(labelColor)
        .cornerRadius(14)
        .font(.headline)
    }

}

extension View {

    func outlineButton(
        labelColor: Color = Color.primary
    ) -> some View {
        modifier(
            OutlineButtonModifier(
                labelColor: labelColor
            )
        )
    }

}

