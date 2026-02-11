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
    @State var scrollOffset: CGFloat = 0

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 24) {
                logo

                if !isShowKeyboard {
                    Texts.signInToYourAccount.value
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.secondary)
                        .scaleOnAppear(isActive: isShowKeyboard)

                    signInButtons

                    HStack {
                        DividerCustom(color: .secondary)

                        Texts.or.value
                            .foregroundColor(.secondary)

                        DividerCustom(color: .secondary)
                    }
                    .opacity(0.5)
                }

                formSignInEmail
            }
            .padding(24)
            .background(.thickMaterial)
            .cornerRadius(24)
            .frame(maxWidth: .infinity, alignment: .center)
            .slideOnAppear(delay: 0.05, direction: .fromTop)

            Spacer()

            HStack {
                Texts.notHaveAccount.value

                Button(action: { viewModel.navigateToSignUpView() }) {
                    Texts.registerYourSelf.value
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }

            Spacer()
        }
        .padding(.top, isShowKeyboard ? 16 : 24)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable(scrollOffset: $scrollOffset) {}
        .animatedBackground(true)
        .background(.accent.opacity(0.9))
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }

    var logo: some View {
        HStack(spacing: 24) {
            Images.logo.image
                .resizable()
                .frame(width: 48, height: 48)

            Images.logoName.image
                .scaleEffect(1.5)
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .slideOnAppear(delay: 0.1, direction: .fromLeft)
        .opacityOnAppear(delay: 0.4, duration: 1)
    }

    var signInButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                hideKeyboard()
                viewModel.signIn(with: .google)
            }) {
                HStack {
                    ImagesHelper.googleIconVector.image
                        .resizable()
                        .frame(width: 24, height: 24)

                    Texts.signInWithGoogle.value
                }
                .frame(maxWidth: .infinity)
            }
            .filledButton(
                isLoading: .constant(viewModel.isLoading == .google),
                backgroundColor: Color(.secondarySystemBackground),
                labelColor: .secondary
            )

            if viewModel.enableAppleSignIn {
                Button(action: { hideKeyboard() }) {
                    HStack {
                        ImagesHelper.appleIconVector.image
                            .resizable()
                            .frame(width: 24, height: 24)

                        Texts.signInWithApple.value
                    }
                    .frame(maxWidth: .infinity)
                }
                .filledButton(backgroundColor: Color(.secondarySystemBackground), labelColor: .secondary)
            }
        }
    }

    var formSignInEmail: some View {
        Group {
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
                    viewModel.signIn(with: .email)
                }) {
                    Text(Texts.signIn.rawValue)
                        .frame(maxWidth: .infinity)
                }
                .filledButton(isLoading: .constant(viewModel.isLoading == .email))
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
