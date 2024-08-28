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

    func resetPassword() {
        Task {
            do {
                isLoading = true
                try await FirebaseAuthService.shared.resetPassword(with: dataForm.email)
                isLoading = false
                navigateToForgotPasswordConfirmationView()
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = false
            }
        }
    }

    func navigateToLogin() {
        NavigationService.shared.resetNavigationAuth()
    }

}

// MARK: - Helper Methods
extension ForgotPasswordViewModel {

    private func navigateToForgotPasswordConfirmationView() {
        NavigationService.shared.navigateTo(.forgotPasswordConfirmationView)
    }

    private func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}
