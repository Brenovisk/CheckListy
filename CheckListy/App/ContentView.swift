//
//  ContentView.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var firebaseAuth = FirebaseAuthService.shared
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            if let isSignIn = firebaseAuth.isSignIn {
                if isSignIn {
                    MainView()
                } else {
                    AuthenticationView()
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct MainView: View {
    var body: some View {
        ListsView()
            .environmentObject(ListsViewModel())
    }
}

struct AuthenticationView: View {
    @State private var showSignUp = false
    
    var body: some View {
        VStack {
            if showSignUp {
                SignUpView()
                    .environmentObject(SignUpViewModel())
            } else {
                SignInView()
                    .environmentObject(SignInViewModel())
            }
            
            ToggleSignUpButton(showSignUp: $showSignUp)
                .padding()
        }
    }
}

struct ToggleSignUpButton: View {
    @Binding var showSignUp: Bool
    
    var body: some View {
        Button(action: {
            showSignUp.toggle()
        }) {
            Text(showSignUp ? "Já tem uma conta? Entrar" : "Se cadastrar")
        }
    }
}

#Preview {
    ContentView()
}
