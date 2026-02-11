//
//  AuthenticationView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct AuthenticationView: View {

    @StateObject private var signInViewModel = SignInViewModel()

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
    AuthenticationView()
}
