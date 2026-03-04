//
//  ToolbarDoneButton.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation
import SwiftUI
import UIKit

struct DoneButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button(TextsHelper.done.rawValue) {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
    }
}

extension View {
    func doneButtonToolbar() -> some View {
        modifier(DoneButtonModifier())
    }
}
