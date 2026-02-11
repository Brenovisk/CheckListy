//
//  RegisterUserUseCase.swift
//  CheckListy
//

import Foundation
import UIKit

class RegisterUserUseCase {
    private let authService: FirebaseAuthService
    // Ideally we would inject UserRepository here too if we extracted the profile creation logic 
    // out of FirebaseAuthService. For now, we wrap the existing service call.
    
    init(authService: FirebaseAuthService = FirebaseAuthService.shared) {
        self.authService = authService
    }
    
    @MainActor
    func execute(data: DataFormSignUp, completion: @escaping (Bool) -> Void) async throws {
        try await authService.signUp(
            withEmail: data.email,
            password: data.password,
            name: data.name,
            uiImage: data.uiImage,
            completion: completion
        )
    }
}
