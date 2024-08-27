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
    
    @StateObject private var loginViewModel = SignInViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()
    
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
                            .environmentObject(loginViewModel)
                            .navigationDestination(for: AppDestinationAuth.self) { destination in
                                switch destination {
                                case .signUpView:
                                    SignUpView()
                                        .environmentObject(signUpViewModel)
                                case .signUpAddPhotoView:
                                    SignUpAddPhotoView()
                                        .environmentObject(signUpViewModel)
                                case .signUpCreatePasswordView:
                                    SignUpCreatePasswordView()
                                        .environmentObject(signUpViewModel)
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
    
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            if viewModel.showStartView {
                StartView()
                    .onStart {
                        viewModel.setShowStartView(to: false)
                    }
                    .onRegister {
                        viewModel.navigateToSignUpView()
                    }
                    .transition(.move(edge: .top))
            } else {
                SignInView()
                    .environmentObject(viewModel)
            }
        }.navigationTitle(String())
    }
    
}

#Preview {
    ContentView()
}
