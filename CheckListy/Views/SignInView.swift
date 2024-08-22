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
    
    var logoSize: CGFloat {
        isShowKeyboard ? 0 : 80
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Images.logo.image
                .resizable()
                .frame(width: logoSize, height: logoSize)
                .transition(.scale)
                .animation(.easeInOut, value: isShowKeyboard)
            
            VStack(alignment: .leading, spacing: 12) {
                Texts.login.value
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Texts.plaseInsertEmail.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
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
                }
                
                HStack {
                    Button(action: { viewModel.navigateToForgotPasswordView() }) {
                        Texts.forgotPassword.value
                            .foregroundColor(Color.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            VStack(spacing: 12){
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
        .padding(.top, isShowKeyboard ? 32 : 80)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable() {}
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 200)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }
    
}

//MARK: typealias
extension SignInView {
    
    typealias Images = ImagesHelper
    typealias Texts  = TextsHelper
    typealias Icons  = IconsHelper
    
}

#Preview {
    SignInView()
        .environmentObject(SignInViewModel())
}
