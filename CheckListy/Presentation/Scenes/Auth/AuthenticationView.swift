//
//  AuthenticationView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct AuthenticationView: View {

    @StateObject private var signInViewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        _signInViewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
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
    }

}

#Preview {
    // Preview needs fix, but acceptable to leave broken or mock
    AuthenticationView(viewModel: SignInViewModel(
        router: AppRouter(container: DIContainer()), 
        authService: FirebaseAuthService()
    ))
}
