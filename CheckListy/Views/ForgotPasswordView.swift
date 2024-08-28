//
//  ForgotPasswordView.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View, KeyboardReadable {

    @EnvironmentObject private var viewModel: ForgotPasswordViewModel
    @State var isShowKeyboard = false

    var email: String

    init(with email: String) {
        self.email = email
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Texts.recoverPassword.value
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Texts.recoverPasswordDescription.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextFieldCustom(
                    text: $viewModel.dataForm.email,
                    placeholder: Texts.email.rawValue,
                    helperText: viewModel.dataForm.emailError,
                    onChanged: { viewModel.dataForm.emailError = nil },
                    isAutoFocused: true
                )
                .keyboardType(.emailAddress)
            }

            Button(action: {
                hideKeyboard()
                guard viewModel.dataForm.isValid() else { return }
                viewModel.resetPassword()
            }) {
                Text(Texts.send.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton(isLoading: $viewModel.isLoading)
        }
        .toolbar(.visible, for: .navigationBar)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable {}
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 164)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
        .onAppear {
            viewModel.dataForm.email = self.email
        }
    }

}

// MARK: typealias
extension ForgotPasswordView {

    typealias Texts = TextsHelper

}

#Preview {
    ForgotPasswordView(with: String())
        .environmentObject(ForgotPasswordViewModel())
}
