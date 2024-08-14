//
//  ForgotPasswordView.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject private var viewModel: ForgotPasswordViewModel
    
    var body: some View {
        VStack {
            Text("Forgot Password")
                .font(.title)
            
            Text("Will send a email to make a redefinition password")
                .font(.subheadline)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        await viewModel.resetPassword()
                    }
                }) {
                    Text("Send")
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
    ForgotPasswordView()
        .environmentObject(ForgotPasswordViewModel(email: String()))
}
