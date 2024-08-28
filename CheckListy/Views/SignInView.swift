//
//  SignInView.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import SwiftUI

struct SignInView: View, KeyboardReadable {
    @EnvironmentObject private var viewModel: SignInViewModel
    @State var isShowKeyboard = false

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 24) {
                Images.logo.image
                    .resizable()
                    .frame(width: 48, height: 48)

                Images.logoName.image
                    .scaleEffect(1.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 32)
            .slideOnAppear(delay: 0.1, direction: .fromLeft)
            .opacityOnAppear(delay: 0.4, duration: 1)

            if !isShowKeyboard {
                Texts.plaseInsertEmail.value
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleOnAppear(isActive: isShowKeyboard)
            }

            VStack(spacing: 16) {
                TextFieldCustom(
                    text: $viewModel.dataForm.email,
                    placeholder: Texts.email.rawValue,
                    helperText: viewModel.dataForm.emailError,
                    onChanged: { viewModel.dataForm.emailError = nil }
                )
                .keyboardType(.emailAddress)

                TextFieldCustom(
                    text: $viewModel.dataForm.password,
                    placeholder: Texts.password.rawValue,
                    helperText: viewModel.dataForm.passwordError,
                    onChanged: { viewModel.dataForm.passwordError = nil },
                    isSecureTextfield: true
                )

                HStack {
                    Button(action: { viewModel.navigateToForgotPasswordView() }) {
                        Texts.forgotPassword.value
                            .foregroundColor(Color.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            VStack(spacing: 12) {
                Button(action: {
                    hideKeyboard()
                    viewModel.signIn()
                }) {
                    Text(Texts.signIn.rawValue)
                        .frame(maxWidth: .infinity)
                }
                .filledButton(isLoading: $viewModel.isLoading)

                HStack {
                    Texts.notHaveAccount.value

                    Button(action: { viewModel.navigateToSignUpView() }) {
                        Texts.registerYourSelf.value
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .padding(.top, isShowKeyboard ? 16 : 24)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable {}
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 200, delay: 1)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }
}

// MARK: typealias

extension SignInView {
    typealias Images = ImagesHelper
    typealias Texts = TextsHelper
    typealias Icons = IconsHelper
}

#Preview {
    SignInView()
        .environmentObject(SignInViewModel())
}
