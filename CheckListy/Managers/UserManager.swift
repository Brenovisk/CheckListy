//
//  UserManager.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation
import UIKit

class UserManager {
    
    static func uploadProfileImage(_ image: UIImage, forUser user: UserDatabase) async throws {
        let userService = UserService(userDatabase: user)
        try await userService.updateUserProfileImage(image)
    }
    
    static func fetchProfileImage(forUserId userId: String) async throws -> UIImage {
        return try await UserService.fetchUserProfileImage(forUserId: userId)
    }
    
    static func updateFirebaseUser(name: String) async throws {
        try await UserService.updateFirebaseUser(displayName: name)
    }
    
    static func updateFirebaseUser(oldPassword: String, to newPassword: String) async throws {
        try await UserService.updateFirebaseUser(oldPassword: oldPassword, to: newPassword)
    }
    
}
