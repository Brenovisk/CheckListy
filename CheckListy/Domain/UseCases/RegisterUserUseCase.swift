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
        
        // Logic previously in UserManager.storeDataBase
        let userProfile = UserProfile(
            id: user.uid,
            name: data.name,
            email: user.email ?? "",
            lists: []
        )
        
        try await userRepository.saveUser(userProfile)
        try await UserService.update(user, displayName: data.name)
        
        if let image = data.uiImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            try await userRepository.saveProfileImage(imageData: imageData, userId: user.uid)
        }
        
        completion(false)
    }
}
