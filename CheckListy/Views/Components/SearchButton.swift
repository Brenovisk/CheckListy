//
//  SearchButton.swift
//  CheckListy
//
//  Created by Breno Lucas on 25/07/24.
//

import Foundation
import SwiftUI

struct SearchButton: View {
    
    var onEnable: (() -> Void)?
    @Binding var isEnable: Bool
    
    private init(isEnable: Binding<Bool>, onEnable: (() -> Void)?) {
        self.init(isEnable: isEnable)
        self.onEnable = onEnable
    }
    
    init(isEnable: Binding<Bool>) {
        self._isEnable = isEnable
    }

    var body: some View {
        Button(action: { onEnable?() }) {
            if isEnable {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .background {
                        Circle()
                            .fill(.primary)
                            .frame(width: 42, height: 42)
                    }
            } else {
                Image(systemName: "magnifyingglass")
            }
        }
    }
    
}

//MARK: - Callback modifiers
extension SearchButton {
    
    func `onEnable`(action: (() -> Void)?) -> SearchButton {
        SearchButton(
            isEnable: self.$isEnable,
            onEnable: action
        )
    }
    
}
