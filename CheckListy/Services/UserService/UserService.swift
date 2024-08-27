//
//  UserService.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation
import UIKit
import Firebase

class UserService {
    
    static func updateProfile(_ image: UIImage, for user: UserDatabase) async throws {
        let imageData = try ImageService.convertImageToData(image)
        let downloadURL = try await ImageService.uploadImageData(imageData, for: user.id)
        let updatedUserDatabase = UserDatabase(id: user.id, name: user.name, urlProfileImage: downloadURL)
        try await updatedUserDatabase.saveToDatabase()
        UserDefaultsService.addImage(.userProfileImage, image)
    }
    
    static func update(_ user: User, displayName: String) async throws {
        try await updateProfile(user) { changeRequest in
            changeRequest.displayName = displayName
        }
    }
    
    static func update(_ user: User, photoUrl: URL) async throws {
        try await updateProfile(user) { changeRequest in
            changeRequest.photoURL = photoUrl
        }
    }
    
    static func update(_ user: User, oldPassword: String, to newPassword: String) async throws {
        try await reauthenticate(user, with: oldPassword)
        try await user.updatePassword(to: newPassword)
    }
    
    static func getUserProfileImage(for userId: String) async throws -> UIImage? {
        guard let url = try await getUrlProfileImage(of: userId) else { return nil }
        let imageData = try await ImageService.downloadImage(fromURL: url)
        let image = try ImageService.convertToUImage(from: imageData)
        return image
    }
    
    static func getUrlProfileImage(of userId: String) async throws -> URL? {
        let user = try await UserService.getUserFromDatabase(with: userId)
        return user.urlProfileImage
    }
    
    static func getEmail(of user: User) throws -> String {
        guard let email = user.email else {
            throw Errors.userNotFoundError
        }
        
        return email
    }
    
    static func removeLists(of user: User) async throws {
        let id = user.uid
        let userLists = findLists(by: id)
        try await remove(userLists, by: id)
    }
    
    static func removePhoto(of user: User) async throws {
        let id = user.uid
        try await ImageService.deletePhoto(name: id)
    }
    
    static func removeFromDataBase(_ user: User) {
        let id = user.uid
        let pathUser = "\(Paths.users)/\(id)"
        FirebaseDatabase.shared.delete(path: pathUser)
    }
    
    static func removeFromFirebaseAuth(_ user: User) async throws {
        try await FirebaseAuthService.shared.deleteAuthUser(user)
    }
    
}

// MARK: Help method
extension UserService {
    
    private static func reauthenticate(_ user: User, with password: String) async throws {
        let email = try getEmail(of: user)
        let authCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await user.reauthenticate(with: authCredential)
    }

    private static func updateProfile(_ user: User, with changes: ChangeRequest) async throws {
         let changeRequest = user.createProfileChangeRequest()
         changes(changeRequest)
         
         do {
             try await changeRequest.commitChanges()
         } catch {
             throw Errors.updateError(error.localizedDescription)
         }
     }
    
}

// MARK: Helper Get methods
extension UserService {
    
    private static func getUserFromDatabase(with id: String) async throws -> UserDatabase {
        try await FirebaseDatabase.shared.getData(from: .users, with: id)
    }
    
}

// MARK: Helper Find methods
extension UserService {
    
    private static func findLists(by userId: String) -> [ListModel] {
        FirebaseDatabase.shared.data.compactMap { $0 }.filter { $0.users.contains(userId) }
    }
    
    private static func findList(by listId: String) -> ListModel? {
        FirebaseDatabase.shared.data.first { $0?.id.uuidString == listId } ?? nil
    }
    
}

// MARK: Helper Remove methods
extension UserService {
    
    private static func remove(_ lists: [ListModel], by userId: String) async throws {
        for list in lists {
            let pathList = "\(Paths.lists.description)/\(list.id)"
            if list.users.count == 1 {
                FirebaseDatabase.shared.delete(path: pathList)
            } else {
                try await remove(list, for: userId, with: pathList)
            }
        }
    }
    
    private static func remove(_ list: ListModel, for userId: String, with path: String) async throws {
        guard var list = findList(by: list.id.uuidString),
              let index = list.users.firstIndex(where: { $0 == userId }) else { return }
        
        list.users.remove(at: index)
        FirebaseDatabase.shared.update(path: path, data: list.toNSDictionary())
    }
    
}

// MARK: - Typealias
extension UserService {
    
    typealias Paths = FirebaseDatabasePaths
    typealias Errors = UserServiceErrors
    typealias ChangeRequest = (UserProfileChangeRequest) -> Void
    
}
