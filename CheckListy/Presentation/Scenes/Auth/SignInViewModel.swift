//
//  SignInViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Combine
import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {

    @Published var dataForm: DataFormSignIn = .init()
    @Published var isLoading: LoadingTypes = .none
    @Published var showPopup: Bool = false

    @Published private(set) var isSecure: Bool = false
    @Published private(set) var showStartView: Bool = true
    @Published private(set) var popupData: PopupData = .init()

    var enableAppleSignIn: Bool = false
    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func signIn(with type: SignInTypes) {
        switch type {
        case .email:
            signInWithEmail()
        case .google:
            signInWithGoogle()
        case .apple:
            signInWithApple()
        }
    }

    @MainActor func signInWithEmail() {
        dataForm.resetErrors()
        guard dataForm.isValid() else { return }

        Task {
            do {
                isLoading = .email
                try await FirebaseAuthService.shared.signIn(
                    withEmail: dataForm.email,
                    password: dataForm.password
                )
                isLoading = .none
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = .none
            }
        }
    }

    @MainActor func signInWithGoogle() {
        Task {
            do {
                isLoading = .google
                FirebaseAuthService.shared.isEnable = false

                guard let user = try await GoogleSignInService.signIn() else { return }

                let userManager = UserManager(authUser: user)
                let alreadyExist = try await userManager.checkUserExistsInDataBase()

                if !alreadyExist {
                    try await userManager.storeDataBase(with: user.displayName ?? String(), and: nil)
                }

                isLoading = .none
                FirebaseAuthService.shared.isEnable = true
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = .none
            }
        }
    }

    @MainActor func signInWithApple() {}

    func setShowStartView(to value: Bool) {
        withAnimation(.easeInOut(duration: 0.5)) {
            showStartView = value
        }
    }

    func setIsSecureToggle() {
        withAnimation {
            isSecure.toggle()
        }
    }

    func navigateToSignUpView() {
        withAnimation {
            NavigationService.shared.navigateTo(.signUpView)
        }
    }

    func navigateToForgotPasswordView() {
        withAnimation {
            NavigationService.shared.navigateTo(.forgotPasswordView(dataForm.email))
        }
    }

    func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}

enum SignInTypes {

    case google
    case apple
    case email

}

enum LoadingTypes {

    case google
    case apple
    case email
    case none

}
