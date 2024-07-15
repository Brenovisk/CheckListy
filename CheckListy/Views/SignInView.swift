//
//  SignInView.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            Text("SignIn")
                .font(.title)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Senha", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        await viewModel.signIn()
                    }
                }) {
                    Text("Entrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let isSignIn = FirebaseAuthService.shared.isSignIn, isSignIn {
                Text("Success!")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
}

#Preview {
    SignInView()
        .environmentObject(SignInViewModel())
}
