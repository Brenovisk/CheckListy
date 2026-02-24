//
//  SignUpViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Combine
import Foundation
import UIKit

class SignUpViewModel: ObservableObject, Hashable, Equatable {

    @Published var isLoading: Bool = false
    @Published var dataForm: DataFormSignUp = .init()
    @Published var showPopup: Bool = false
    @Published private(set) var popupData: PopupData = .init()

    private var cancellables = Set<AnyCancellable>()
    private let registerUserUseCase: RegisterUserUseCase
    private let router: AppRouter
    
    init(router: AppRouter, registerUserUseCase: RegisterUserUseCase) {
        self.router = router
        self.registerUserUseCase = registerUserUseCase
    }
    
    static func == (lhs: SignUpViewModel, rhs: SignUpViewModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    @MainActor
    func signUp() {
        Task {
            do {
                isLoading = true
                try await registerUserUseCase.execute(data: dataForm) { [weak self] isDone in
                    self?.isLoading = isDone
                }
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = false
            }
        }
    }

    @MainActor
    func navigateToSignUpAddPhotoView() {
        router.navigate(to: .signUpAddPhoto(self))
    }

    @MainActor
    func navigateToSignUpCreatePassword() {
        router.navigate(to: .signUpCreatePassword(self))
    }

    func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}
