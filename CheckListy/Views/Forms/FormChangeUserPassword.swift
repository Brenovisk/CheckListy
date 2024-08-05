//
//  FormChangeUserPassword.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct FormChangeUserPassword: View {
    
    @State private var newPassword: String = String()
    @State private var oldPassword: String = String()
    
    var onSave: (((String, String)) -> Void)?
    var onClose: (() -> Void)?
    
    private init(onSave: (((String, String)) -> Void)?, onClose: (() -> Void)?) {
        self.onSave = onSave
        self.onClose = onClose
        
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    init() {}
    
    var body: some View {
        NavigationView{
            Form{
                AutoFocusTextField(text: $oldPassword, placeholder: "Senha antiga", isSecureTextEntry: true)
                
                SecureField("Nova Senha", text: $newPassword)
            }
            .navigationTitle("Mudar Senha")
            .navigationBarItems(
                leading: Button(action: { onClose?() }) {
                    Text("Cancelar")
                },
                trailing:
                    Button(action: {
                        onSave?((oldPassword, newPassword))
                    }) {
                        Text("Mudar")
                    }
            )
        }
    }
}

// MARK: - Callbacks modifiers
extension FormChangeUserPassword {
    
    func `onSave`(action: (((String, String)) -> Void)?) -> FormChangeUserPassword {
        FormChangeUserPassword(
            onSave: action,
            onClose: self.onClose
        )
    }
    
    func `onClose`(action: (() -> Void)?) -> FormChangeUserPassword {
        FormChangeUserPassword(
            onSave: self.onSave,
            onClose: action
        )
    }
    
}

#Preview {
    NavigationView {
        FormChangeUserPassword()
    }
}
