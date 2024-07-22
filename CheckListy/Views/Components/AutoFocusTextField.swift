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

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.text = text
        textField.placeholder = placeholder // Configura o placeholder

        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder // Atualiza o placeholder se necessário
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
