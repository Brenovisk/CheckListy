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

    static func updateProfile(_ image: UIImage, for user: UserDatabase) async throws {
        let imageData = try ImageService.convertImageToData(image)
        let downloadURL = try await ImageService.uploadImageData(imageData, for: user.id)
        let updatedUserDatabase = UserDatabase(id: user.id, name: user.name, urlProfileImage: downloadURL, lists: user.lists)
        try await updatedUserDatabase.saveToDatabase()
        UserDefaultsService.addImage(.userDatabaseImage, image)
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

    static func getUserDatabaseImage(for userId: String) async throws -> UIImage? {
        if let imageStored = getImageStoredIfExist(for: userId) {
            return imageStored
        }

        guard let url = try await getUrlProfileImage(of: userId) else { return nil }
        let imageData = try await ImageService.downloadImage(fromURL: url)
        let image = try ImageService.convertToUImage(from: imageData)
        try store(imageData, for: userId)
        return image
    }

    static func getUrlLocalImage(for userId: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(userId).png")
    }

    static func getImageStoredIfExist(for userId: String) -> UIImage? {
        let imageFileUrl = getUrlLocalImage(for: userId)

        guard FileManager.default.fileExists(atPath: imageFileUrl.path),
              let imageData = try? Data(contentsOf: imageFileUrl),
              let image = UIImage(data: imageData)

        else {
            return nil
        }

        return image
    }

    static func store(_ imageData: Data, for userId: String) throws {
        let imageFileUrl = getUrlLocalImage(for: userId)

        do {
            try imageData.write(to: imageFileUrl)
            debugPrint("Image Stored: \(imageFileUrl.path)")
        } catch {
            throw Errors.storeImage
        }
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
        let userLists = findLists(user: user, by: id)
        try await remove(userLists)
    }

    static func removeProfileImage(of user: User) async throws {
        let urlImage = try await getUrlProfileImage(of: user.uid)

        if urlImage != nil {
            try await removePhoto(of: user)
        }
    }

    static func removePhoto(of user: User) async throws {
        let id = user.uid
        try await ImageService.deletePhoto(name: id)
    }

    static func removeFromDataBase(_ user: User) async throws {
        try await removeLists(of: user)

        let id = user.uid
        let pathUser = "\(Paths.users)/\(id)"
        FirebaseDatabase.shared.delete(path: pathUser)
    }

    static func reauthtenticateWithFirebaseAuth(_ user: User, with password: String) async throws {
        try await FirebaseAuthService.shared.reauthenticateAuthUser(user, with: password)
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

    private static func findLists(user: User, by _: String) -> [String] {
        FirebaseDatabase.shared.data.filter { $0?.owner == user.uid }.compactMap { $0?.id.uuidString }
    }

    private static func findList(by listId: String) -> ListModel? {
        FirebaseDatabase.shared.data.first { $0?.id.uuidString == listId } ?? nil
    }

}

// MARK: Helper Remove methods

extension UserService {

    private static func remove(_ lists: [String]) async throws {
        for listId in lists {
            let pathList = "\(Paths.lists.description)/\(listId)"
            FirebaseDatabase.shared.delete(path: pathList)
        }
    }

}

// MARK: - Typealias

extension UserService {

    typealias Paths = FirebaseDatabasePaths
    typealias Errors = UserServiceErrors
    typealias ChangeRequest = (UserProfileChangeRequest) -> Void
}
