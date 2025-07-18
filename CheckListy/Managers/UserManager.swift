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

    init(authUser: User) {
        self.authUser = authUser
    }

    func update(name: String, of user: UserDatabase) async throws {
        try await UserService.update(authUser, displayName: name)

        let updatedUserDatabase = UserDatabase(id: user.id, name: name, urlProfileImage: user.urlProfileImage, lists: user.lists)

        try await updatedUserDatabase.saveToDatabase()
    }

    func update(oldPassword: String, to newPassword: String) async throws {
        try await UserService.update(authUser, oldPassword: oldPassword, to: newPassword)
    }

    func removeUserData(with password: String) async throws {
        try await UserService.reauthtenticateWithFirebaseAuth(authUser, with: password)
        try await UserService.removeLists(of: authUser)
        try await UserService.removeProfileImage(of: authUser)
        try await UserService.removeFromDataBase(authUser)
        try await UserService.removeFromFirebaseAuth(authUser)
    }

    func storeDataBase(with name: String, and image: UIImage?) async throws {
        let userData = UserDatabase(id: authUser.uid, name: name, urlProfileImage: URL(string: String()))
        try await userData.saveToDatabase()
        try await UserService.update(authUser, displayName: name)
        guard let image else { return }
        try await UserService.updateProfile(image, for: userData)
    }

    static func uploadProfile(_ image: UIImage, for user: UserDatabase) async throws {
        try await UserService.updateProfile(image, for: user)
    }

    func getProfileImage() async throws -> UIImage? {
        try await UserService.getUserDatabaseImage(for: authUser.uid)
    }

    func getUrlProfileImage() async throws -> URL? {
        try await UserService.getUrlProfileImage(of: authUser.uid)
    }

    func getEmail() throws -> String {
        try UserService.getEmail(of: authUser)
    }

    @MainActor
    func getList() async throws -> [String] {
        let user: UserDatabase = try await FirebaseDatabase.shared.getData(from: .users, with: authUser.uid)
        return user.lists
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
        let image = try await UserService.getUserDatabaseImage(for: authUser.uid)
        return image
    }

    func checkUserExistsInDataBase() async throws -> Bool {
        try await FirebaseDatabase.shared.checkIfItemExist(with: authUser.uid, in: .users)
    }

}
