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
    @State var isKeyboardEnable = false
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack {
            Images.logo.image
                .resizable()
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 12) {
                Texts.login.value
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Texts.plaseInsertEmail.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
            
            TextFieldCustom(
                text: $viewModel.email, 
                placeholder: Texts.email.rawValue
            )
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .padding(.top, 24)
            
            TextFieldCustom(
                text: $viewModel.password, 
                placeholder: Texts.password.rawValue,
                isSecureTextfield: true
            )
            .padding(.top, 24)
            
            HStack {
                Spacer()
                
                Button(action: { viewModel.navigateToForgotPasswordView() }) {
                    Texts.forgotPassword.value
                        .foregroundColor(Color.accentColor)
                }
            }.padding(.top, 16)
            
            if !isKeyboardEnable {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .foregroundColor(Color.accentColor)
                            .padding()
                    } else {
                        Button(action: { viewModel.signIn() }) {
                            Text(Texts.signIn.rawValue)
                                .frame(maxWidth: .infinity)
                        }
                        .filledButton()
                    }
                }
                .padding(.top, 32)
                
                HStack {
                    Texts.notHaveAccount.value
                    
                    Button(action: { viewModel.navigateToSignUpView() }) {
                        Texts.registerYourSelf.value
                            .foregroundColor(.accentColor)
                    }
                }.padding(.top, 12)
            }
        }
        .padding(.top, 80)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 200)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isKeyboardEnable = value
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
