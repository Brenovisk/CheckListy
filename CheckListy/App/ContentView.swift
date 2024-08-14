//
//  ContentView.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var firebaseAuthService = FirebaseAuthService.shared
    @StateObject private var navigationService = NavigationService.shared
    var viewModel = SignInViewModel()
    
    var body: some View {
        VStack {
            if let isSignIn = firebaseAuthService.isSignIn {
                if isSignIn && firebaseAuthService.isEnable {
                    NavigationStack(path: $navigationService.navigationPath) {
                        MainView()
                            .navigationDestination(for: AppDestination.self) { destination in
                                switch destination {
                                case .detailsListView(let list):
                                    DetailsListView()
                                        .environmentObject(DetailsListViewModel(list))
                                case .profileView:
                                    ProfileView()
                                        .environmentObject(ProfileViewModel())
                                }
                            }
                    }
                } else {
                    NavigationStack(path: $navigationService.navigationPathAuth) {
                        AuthenticationView()
                            .environmentObject(viewModel)
                            .navigationDestination(for: AppDestinationAuth.self) { destination in
                                switch destination {
                                case .singUpView:
                                    SignUpView()
                                        .environmentObject(SignUpViewModel())
                                case .forgotPasswordView(let email):
                                    ForgotPasswordView()
                                        .environmentObject(ForgotPasswordViewModel(email: email))
                                }
                            }
                    }
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
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            SignInView()
                .environmentObject(viewModel)
            
            Button(action: { NavigationService.shared.navigateTo(.singUpView) }) {
                Text("Se cadastrar")
            }
            
            Button(action: { NavigationService.shared.navigateTo(.forgotPasswordView(viewModel.email)) }) {
                Text("Esqueci a senha")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
