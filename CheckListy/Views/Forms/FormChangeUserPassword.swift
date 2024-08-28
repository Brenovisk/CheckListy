//
//  FormChangeUserPassword.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct FormChangeUserPassword: View {
    @State private var newPassword: String = .init()
    @State private var oldPassword: String = .init()
    @Binding var isLoading: Bool
    @State private var termsAccepted = false

    var onSave: (((String, String)) -> Void)?
    var onClose: (() -> Void)?

    private init(
        isLoading: Binding<Bool>,
        onSave: (((String, String)) -> Void)?,
        onClose: (() -> Void)?
    ) {
        self.init(isLoading: isLoading)
        self.onSave = onSave
        self.onClose = onClose

        UITextField.appearance().clearButtonMode = .whileEditing
    }

    init(isLoading: Binding<Bool>) {
        _isLoading = isLoading
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
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
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Mudar")
                        }
                    }
                )
            }
            .interactiveDismissDisabled(!termsAccepted && isLoading)
        }
    }
}

// MARK: - Callbacks modifiers

extension FormChangeUserPassword {
    func onSave(action: (((String, String)) -> Void)?) -> FormChangeUserPassword {
        FormChangeUserPassword(
            isLoading: $isLoading,
            onSave: action,
            onClose: onClose
        )
    }

    func onClose(action: (() -> Void)?) -> FormChangeUserPassword {
        FormChangeUserPassword(
            isLoading: $isLoading,
            onSave: onSave,
            onClose: action
        )
    }
}

#Preview {
    NavigationView {
        FormChangeUserPassword(isLoading: Binding.constant(false))
    }
}
