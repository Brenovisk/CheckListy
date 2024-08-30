//
//  AuthenticationView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct AuthenticationView: View {

    @StateObject private var navigationService = NavigationService.shared
    @StateObject private var signInViewModel = SignInViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()
    @StateObject private var forgotPasswordViewModel = ForgotPasswordViewModel()

    var body: some View {
        NavigationStack(path: $navigationService.navigationPathAuth) {
            @EnvironmentObject var viewModel: SignInViewModel
            VStack {
                if signInViewModel.showStartView {
                    StartView()
                        .onStart {
                            signInViewModel.setShowStartView(to: false)
                        }
                        .onRegister {
                            signInViewModel.navigateToSignUpView()
                        }
                        .transition(.move(edge: .top))
                } else {
                    SignInView()
                        .environmentObject(signInViewModel)
                }
            }
            .navigationTitle(String())
            .environmentObject(signInViewModel)
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
                case let .forgotPasswordView(email):
                    ForgotPasswordView(with: email)
                        .environmentObject(forgotPasswordViewModel)
                case .forgotPasswordConfirmationView:
                    ForgotPasswordConfirmationView()
                        .environmentObject(forgotPasswordViewModel)
                }
            }
        }
    }

}

#Preview {
    AuthenticationView()
}
