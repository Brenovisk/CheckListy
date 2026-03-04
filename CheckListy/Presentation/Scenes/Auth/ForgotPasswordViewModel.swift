//
//  ForgotPasswordViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {

    @Published var dataForm: DataFormForgotPassword = .init()
    @Published var isLoading: Bool = false
    @Published var showPopup: Bool = false

    @Published private(set) var popupData: PopupData = .init()
    
    private let router: AppRouter
    private let authService: FirebaseAuthService
    
    init(router: AppRouter, authService: FirebaseAuthService) {
        self.router = router
        self.authService = authService
    }

    @MainActor
    func resetPassword() async {
        do {
            isLoading = true
            try await authService.resetPassword(with: dataForm.email)
            isLoading = false
            navigateToForgotPasswordConfirmationView()
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
            isLoading = false
        }
    }

    @MainActor
    func navigateToLogin() {
        router.popToRoot()
    }

}

// MARK: - Helper Methods
extension ForgotPasswordViewModel {

    @MainActor
    private func navigateToForgotPasswordConfirmationView() {
        router.navigate(to: .forgotPasswordConfirmation)
    }

    private func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}
