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
    
    init(router: AppRouter, authService: FirebaseAuthService) {
        self.router = router
        self.authService = authService
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

                // Ideally UserManager should be injected too, but it creates its own repo internally or we inject it. 
                // We'll use default for now or fix UserManager later.
                // UserManager default init uses UserRepository default init which uses FirebaseDatabase().
                // This is acceptable for now but not strict DI.
                let userManager = UserManager(authUser: user) 
                let alreadyExist = try await userManager.checkUserExistsInDataBase()

                if !alreadyExist {
                    try await userManager.storeDataBase(with: user.displayName ?? String(), and: nil)
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

    func navigateToSignUpView() {
        withAnimation {
            router.navigate(to: .signUp)
        }
    }

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
