//
//  SignUpCreatePasswordView.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/08/24.
//

import Foundation
import SwiftUI

struct SignUpCreatePasswordView: View, KeyboardReadable {

    @EnvironmentObject private var viewModel: SignUpViewModel

    @State var isShowKeyboard = false
    @State var scrollOffset: CGFloat = 0

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Texts.createASecurePassword.value
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)

                Texts.createASecureDescription.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextFieldCustom(
                    text: $viewModel.dataForm.password,
                    placeholder: Texts.password.rawValue,
                    helperText: viewModel.dataForm.passwordError,
                    onChanged: { viewModel.dataForm.passwordError = nil },
                    isSecureTextfield: true,
                    isAutoFocused: true
                )

                TextFieldCustom(
                    text: $viewModel.dataForm.confirmationPassword,
                    placeholder: Texts.confirmPassword.rawValue,
                    helperText: viewModel.dataForm.confirmationPasswordError,
                    onChanged: { viewModel.dataForm.confirmationPasswordError = nil },
                    isSecureTextfield: true
                )
            }

            Button(action: {
                hideKeyboard()
                guard viewModel.dataForm.isValidPasswordAndConfirmation() else { return }
                viewModel.signUp()
            }) {
                Text(Texts.create.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton(isLoading: $viewModel.isLoading)
        }
        .toolbar(.visible, for: .navigationBar)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable(scrollOffset: $scrollOffset) {}
        .animatedBackground()
        .gradientTopDynamic(color: Color.accentColor, height: 164, scrollOffset: $scrollOffset)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }

}

// MARK: typealias

extension SignUpCreatePasswordView {
    typealias Texts = TextsHelper
}

#Preview {
    NavigationStack {
        SignUpCreatePasswordView()
            .environmentObject(SignUpViewModel())
    }
}
