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
    
    private let router: AppRouter
    private let authService: FirebaseAuthService
    private let userRepository: UserRepositoryProtocol
    private let userService: UserService
    
    init(router: AppRouter, authService: FirebaseAuthService, userRepository: UserRepositoryProtocol, userService: UserService) {
        self.router = router
        self.authService = authService
        self.userRepository = userRepository
        self.userService = userService
    }

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
                try await authService.signIn(
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
                authService.isEnable = false

                guard let user = try await GoogleSignInService.signIn() else { return }

                // Check if user exists
                var userExists = false
                do {
                    _ = try await userRepository.fetchUser(userId: user.uid)
                    userExists = true
                } catch {
                    userExists = false
                }

                if !userExists {
                    let userProfile = UserProfile(
                        id: user.uid,
                        name: user.displayName ?? "",
                        email: user.email ?? "",
                        lists: []
                    )
                    try await userRepository.saveUser(userProfile)
                    try await userService.update(user, displayName: user.displayName ?? "")
                }

                isLoading = .none
                authService.isEnable = true
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

    @MainActor
    func navigateToSignUpView() {
        withAnimation {
            router.navigate(to: .signUp)
        }
    }

    @MainActor
    func navigateToForgotPasswordView() {
        withAnimation {
            router.navigate(to: .forgotPassword(dataForm.email))
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
