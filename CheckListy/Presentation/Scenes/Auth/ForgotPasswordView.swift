//
//  ForgotPasswordView.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View, KeyboardReadable {

    @StateObject var viewModel: ForgotPasswordViewModel
    @State var isShowKeyboard = false
    @State var scrollOffset: CGFloat = 0

    init(viewModel: ForgotPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                Task {
                    await viewModel.resetPassword()
                }
            }) {
                Text(Texts.send.rawValue)
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
extension ForgotPasswordView {

    typealias Texts = TextsHelper

}

#Preview {
    ForgotPasswordView(viewModel: ForgotPasswordViewModel(
        router: AppRouter(container: DIContainer()),
        authService: FirebaseAuthService()
    ))
}
