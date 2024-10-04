//
//  SearchButton.swift
//  CheckListy
//
//  Created by Breno Lucas on 25/07/24.
//

import Foundation
import SwiftUI

struct SearchButton: View {

    @Binding var isEnable: Bool

    var onEnable: (() -> Void)?
    var size: Double

    private init(isEnable: Binding<Bool>, size: Double = 24, onEnable: (() -> Void)?) {
        self.init(isEnable: isEnable, size: size)
        self.onEnable = onEnable
    }

    init(isEnable: Binding<Bool>, size: Double = 24) {
        _isEnable = isEnable
        self.size = size
    }

    var body: some View {
        Button(action: { onEnable?() }) {
            if isEnable {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .background {
                        Circle()
                            .fill(.primary)
                            .frame(width: 42, height: 42)
                    }
            } else {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
    }

}

// MARK: - Callback modifiers
extension SearchButton {

    func onEnable(action: (() -> Void)?) -> SearchButton {
        SearchButton(
            isEnable: $isEnable,
            size: size,
            onEnable: action
        )
    }

}
