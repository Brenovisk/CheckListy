//
//  UserService.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Firebase
import Foundation
import UIKit

class UserService {

    private let firebaseDatabase: FirebaseDatabase
    private let firebaseAuthService: FirebaseAuthService

    init(firebaseDatabase: FirebaseDatabase, firebaseAuthService: FirebaseAuthService) {
        self.firebaseDatabase = firebaseDatabase
        self.firebaseAuthService = firebaseAuthService
    }

    func update(_ user: User, displayName: String) async throws {
        try await updateProfile(user) { changeRequest in
            changeRequest.displayName = displayName
        }
    }

    func update(_ user: User, photoUrl: URL) async throws {
        try await updateProfile(user) { changeRequest in
            changeRequest.photoURL = photoUrl
        }
    }

    func update(_ user: User, oldPassword: String, to newPassword: String) async throws {
        try await reauthenticate(user, with: oldPassword)
        try await user.updatePassword(to: newPassword)
    }

    func getEmail(of user: User) throws -> String {
        guard let email = user.email else {
            throw Errors.userNotFoundError
        }

        return email
    }

    func removeLists(of user: User) async throws {
        let id = user.uid
        let userLists = findLists(user: user, by: id)
        try await remove(userLists)
    }

    func removeFromDataBase(_ user: User) async throws {
        try await removeLists(of: user)

        let id = user.uid
        let pathUser = "\(Paths.users)/\(id)"
        firebaseDatabase.delete(path: pathUser)
    }

    func reauthtenticateWithFirebaseAuth(_ user: User, with password: String) async throws {
        try await firebaseAuthService.reauthenticateAuthUser(user, with: password)
    }

    func removeFromFirebaseAuth(_ user: User) async throws {
        try await firebaseAuthService.deleteAuthUser(user)
    }

}

// MARK: Help method
extension UserService {

    private func reauthenticate(_ user: User, with password: String) async throws {
        let email = try getEmail(of: user)
        let authCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await user.reauthenticate(with: authCredential)
    }

    private func updateProfile(_ user: User, with changes: ChangeRequest) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changes(changeRequest)

        do {
            try await changeRequest.commitChanges()
        } catch {
            throw Errors.updateError(error.localizedDescription)
        }
    }

}

// MARK: Helper Find methods
extension UserService {

    private func findLists(user: User, by _: String) -> [String] {
        firebaseDatabase.data.filter { $0?.owner == user.uid }.compactMap { $0?.id.uuidString }
    }

}

// MARK: Helper Remove methods
extension UserService {

    private func remove(_ lists: [String]) async throws {
        for listId in lists {
            let pathList = "\(Paths.lists.description)/\(listId)"
            firebaseDatabase.delete(path: pathList)
        }
    }

}

// MARK: - Typealias
extension UserService {

    typealias Paths = FirebaseDatabasePaths
    typealias Errors = UserServiceErrors
    typealias ChangeRequest = (UserProfileChangeRequest) -> Void
}
