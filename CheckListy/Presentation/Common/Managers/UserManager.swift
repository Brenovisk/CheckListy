//
//  UserManager.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Firebase
import FirebaseAuth
import Foundation
import UIKit

class UserManager {

    var authUser: User
    private let repository: UserRepositoryProtocol

    init(authUser: User, repository: UserRepositoryProtocol) {
        self.authUser = authUser
        self.repository = repository
    }

    func update(name: String, of user: UserDatabase) async throws {
        try await UserService.update(authUser, displayName: name)

        let userProfile = UserProfile(
            id: user.id,
            name: name,
            email: user.email,
            lists: user.lists
        )
        try await repository.saveUser(userProfile)
    }

    func update(oldPassword: String, to newPassword: String) async throws {
        try await UserService.update(authUser, oldPassword: oldPassword, to: newPassword)
    }

    func removeUserData(with password: String) async throws {
        try await UserService.reauthtenticateWithFirebaseAuth(authUser, with: password)
        try await UserService.removeLists(of: authUser)
        
        try await UserService.removeFromDataBase(authUser)
        try await UserService.removeFromFirebaseAuth(authUser)
    }

    func storeDataBase(with name: String, and image: UIImage?) async throws {
        let userProfile = UserProfile(
            id: authUser.uid,
            name: name,
            email: authUser.email ?? "",
            lists: []
        )
        try await repository.saveUser(userProfile)
        try await UserService.update(authUser, displayName: name)
        
        if let image = image, let data = image.jpegData(compressionQuality: 0.8) {
            try await repository.saveProfileImage(imageData: data, userId: authUser.uid)
        }
    }

    func uploadProfile(_ image: UIImage, for user: UserDatabase) async throws {
        if let data = image.jpegData(compressionQuality: 0.8) {
            try await repository.saveProfileImage(imageData: data, userId: user.id)
        }
    }

    func getProfileImage() async throws -> UIImage? {
        if let data = try await repository.getProfileImageData(userId: authUser.uid) {
            return UIImage(data: data)
        }
        return nil
    }

    func getUrlProfileImage() async throws -> URL? {
        return nil 
    }

    func getEmail() throws -> String {
        try UserService.getEmail(of: authUser)
    }

    @MainActor
    func getList() async throws -> [String] {
        let userProfile = try await repository.fetchUser(userId: authUser.uid)
        return userProfile.lists
    }

    func getId() -> String {
        authUser.uid
    }

    func getName() -> String {
        let storedName = UserDefaultsService.loadItem(.userName)

        if !storedName.isEmpty {
            return storedName
        }

        let name = authUser.displayName ?? String()
        UserDefaultsService.add(.userName, name)
        return name
    }

    func getImage() async throws -> UIImage? {
        return try await getProfileImage()
    }

    func checkUserExistsInDataBase() async throws -> Bool {
        do {
            _ = try await repository.fetchUser(userId: authUser.uid)
            return true
        } catch {
            return false
        }
    }

}
