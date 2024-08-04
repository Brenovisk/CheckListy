//
//  SignUpView.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var viewModel: SignUpViewModel
    
    var body: some View {
        VStack {
            Text("SignUp")
                .font(.title)
            
            ImagePicker(image: nil)
                .onPick { imageUrl in
                    viewModel.uiImage = imageUrl
                }
            
            TextField("Nome", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
                        await viewModel.signUp()
                    }
                }) {
                    Text("Cadastrar")
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
        }
        .padding()
    }
    
}

#Preview {
    SignUpView()
        .environmentObject(SignUpViewModel())
}
