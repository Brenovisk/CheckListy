//
//  RoundedBackgroundTextFieldStyle.swift
//  CheckListy
//
//  Created by Breno Lucas on 16/07/24.
//

import Foundation
import SwiftUI

struct RoundedBackgroundTextFieldStyle<Suffix: View>: ViewModifier {
    let suffix: Suffix

    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .frame(height: 44)
    }
}

extension View {
    func roundedBackgroundTextField<Suffix: View>(@ViewBuilder suffix: () -> Suffix = { EmptyView() }) -> some View {
        modifier(RoundedBackgroundTextFieldStyle(suffix: suffix()))
    }
}
