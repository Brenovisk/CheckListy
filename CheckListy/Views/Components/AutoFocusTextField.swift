//
//  AutoFocusTextField.swift
//  CheckListy
//
//  Created by Breno Lucas on 16/07/24.
//

import Foundation
import SwiftUI

struct AutoFocusTextField: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String
    var isSecureTextEntry: Bool = false

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = context.coordinator
        textField.text = text
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            textField.becomeFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context _: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }

}

class Coordinator: NSObject, UITextFieldDelegate {

    var parent: AutoFocusTextField

    init(parent: AutoFocusTextField) {
        self.parent = parent
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.parent.text = textField.text ?? ""
        }
    }

}
