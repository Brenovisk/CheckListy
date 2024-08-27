//
//  SignInViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import Combine
import SwiftUI

class SignInViewModel: ObservableObject {
    
    @Published var dataForm: DataFormSignIn = DataFormSignIn()
    @Published var isLoading: Bool = false
    @Published var showPopup: Bool = false
    
    @Published private(set) var isSecure: Bool = false
    @Published private(set) var showStartView: Bool = true
    @Published private(set) var popupData: PopupData = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func signIn() {
        dataForm.resetErrors()
        guard dataForm.isValid() else { return }
                
        Task {
            do {
                isLoading = true
                try await FirebaseAuthService.shared.signIn(
                    withEmail: dataForm.email,
                    password: dataForm.password
                )
                isLoading = false
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = false
            }
        }
    }
    
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
