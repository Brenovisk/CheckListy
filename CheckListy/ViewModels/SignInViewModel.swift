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
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showPopup: Bool = false
    
    @Published private(set) var isSecure: Bool = false
    @Published private(set) var showStartView: Bool = true
    @Published private(set) var popupData: PopupData = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func signIn() {
        Task {
            do {
                isLoading = true
                try await FirebaseAuthService.shared.signIn(withEmail: email, password: password)
                isLoading = false
            } catch {
                errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage ?? String())
                isLoading = false
            }
        }
    }
    
    func setShowStartView(to value: Bool)  {
        withAnimation(.easeInOut(duration: 0.5)) {
            showStartView = value
        }
    }    
    
    func setIsSecureToggle()  {
        withAnimation {
            isSecure.toggle()
        }
    }
    
    func navigateToSignUpView()  {
        withAnimation {
            NavigationService.shared.navigateTo(.singUpView)
        }
    }    
    
    func navigateToForgotPasswordView()  {
        withAnimation {
            NavigationService.shared.navigateTo(.forgotPasswordView(email))
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
