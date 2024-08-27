//
//  SignUpViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var dataForm: DataFormSignUp = DataFormSignUp()
    @Published var showPopup: Bool = false
    @Published private(set) var popupData: PopupData = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    func signUp() {
        Task {
            do {
                isLoading = true
                try await FirebaseAuthService.shared.signUp(
                    withEmail: dataForm.email,
                    password: dataForm.password,
                    name: dataForm.name,
                    uiImage: dataForm.uiImage
                ) { isDone in
                    isLoading = isDone
                }
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = false
            }
        }
    }
    
    func navigateToSignUpAddPhotoView() {
        NavigationService.shared.navigateTo(.signUpAddPhotoView)
    }
    
    func navigateToSignUpCreatePassword() {
        NavigationService.shared.navigateTo(.signUpCreatePasswordView)
    }
    
    func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }
    
}
