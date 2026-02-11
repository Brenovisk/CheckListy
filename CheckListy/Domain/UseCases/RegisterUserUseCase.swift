//
//  RegisterUserUseCase.swift
//  CheckListy
//

import Foundation
import UIKit
import Firebase

class RegisterUserUseCase {
    private let authService: FirebaseAuthService
    private let userRepository: UserRepositoryProtocol
    
    init(authService: FirebaseAuthService, userRepository: UserRepositoryProtocol) {
        self.authService = authService
        self.userRepository = userRepository
    }
    
    @MainActor
    func execute(data: DataFormSignUp, completion: @escaping (Bool) -> Void) async throws {
        let user = try await authService.signUp(
            withEmail: data.email,
            password: data.password
        )
        
        let manager = UserManager(authUser: user, repository: userRepository)
        try await manager.storeDataBase(with: data.name, and: data.uiImage)
        completion(false)
    }
}
