//
//  FormUserProfile.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct FormUserProfile: View {
    @Binding var user: UserProfile?
    @Binding var isLoading: Bool
    @State private var id: String
    @State private var name: String
    @State private var email: String
    @State private var image: UIImage?
    @State private var termsAccepted = false

    var onSave: ((UserProfile) -> Void)?
    var onClose: (() -> Void)?

    private init(
        user: Binding<UserProfile?>,
        isLoading: Binding<Bool>,
        onSave: ((UserProfile) -> Void)?,
        onClose: (() -> Void)?
    ) {
        self.init(user: user, isLoading: isLoading)
        self.onSave = onSave
        self.onClose = onClose

        UITextField.appearance().clearButtonMode = .whileEditing
    }

    init(user: Binding<UserProfile?>, isLoading: Binding<Bool>) {
        _user = user
        _isLoading = isLoading
        _id = State(initialValue: user.wrappedValue?.id ?? String())
        _name = State(initialValue: user.wrappedValue?.name ?? String())
        _email = State(initialValue: user.wrappedValue?.email ?? String())
        _image = State(initialValue: user.wrappedValue?.profileImage)
    }

    var body: some View {
        NavigationView {
            VStack {
                ImagePicker(image: image)
                    .onPick { uiImage in
                        self.image = uiImage
                    }
                    .padding(.top, 16)

                Form {
                    AutoFocusTextField(text: $name, placeholder: String())
                }
                .navigationTitle("Editar Perfil")
                .navigationBarItems(
                    leading: Button(action: { onClose?() }) {
                        Text("Cancelar")
                    },
                    trailing:
                    Button(action: {
                        let user = UserProfile(
                            id: id,
                            name: name,
                            urlProfileImage: user?.urlProfileImage,
                            profileImage: image,
                            email: email
                        )

                        onSave?(user)
                    }) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Editar")
                        }
                    }
                )
            }
            .interactiveDismissDisabled(!termsAccepted && isLoading)
        }
    }
}

// MARK: - Callbacks modifiers
extension FormUserProfile {

    func onSave(action: ((UserProfile) -> Void)?) -> FormUserProfile {
        FormUserProfile(
            user: $user,
            isLoading: $isLoading,
            onSave: action,
            onClose: onClose
        )
    }

    func onClose(action: (() -> Void)?) -> FormUserProfile {
        FormUserProfile(
            user: $user,
            isLoading: $isLoading,
            onSave: onSave,
            onClose: action
        )
    }

}

#Preview {
    NavigationView {
        FormUserProfile(user: Binding.constant(UserProfile(id: String(), name: "Teste", email: "test@gmail.com")), isLoading: Binding.constant(false))
    }
}
