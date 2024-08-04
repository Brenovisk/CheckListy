//
//  UserService.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation
import UIKit

class UserService {
    
    let userDatabase: UserDatabase
    
    init(userDatabase: UserDatabase) {
        self.userDatabase = userDatabase
    }
    
    func updateUserProfileImage(_ image: UIImage) async throws {
        let imageData = try ImageService.convertImageToData(image)
        let downloadURL = try await ImageService.uploadImageData(imageData, forUserId: userDatabase.id)
        let updatedUserDatabase = UserDatabase(id: userDatabase.id, name: userDatabase.name, urlProfileImage: downloadURL)
        try await updatedUserDatabase.saveToDatabase()
    }
    
    static func fetchUserProfileImage(forUserId userId: String) async throws -> UIImage {
        let user = try await UserService.fetchFromDatabase(withId: userId)
        
        guard let url = user.urlProfileImage else {
            throw NSError(domain: "url Error", code: -1, userInfo: nil)
        }
        
        let imageData = try await ImageService.downloadImage(fromURL: url)
        
        guard let image = UIImage(data: imageData) else {
            throw NSError(domain: "ImageDataError", code: -1, userInfo: nil)
        }
        
        return image
    }
    
    static func updateFirebaseUser(displayName: String) async throws {
        guard let currentUser = await FirebaseAuthService.shared.getAuthUser() else {
            throw NSError(domain: "UserNotFoundError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        let _: Data = try await withCheckedThrowingContinuation { continuation in
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: Data())
                }
            }
        }
    }
    
    static func updateFirebaseUser(photoUrl: URL) async throws {
        guard let currentUser = await FirebaseAuthService.shared.getAuthUser() else {
            throw NSError(domain: "UserNotFoundError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        let _: Data = try await withCheckedThrowingContinuation { continuation in
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.photoURL = photoUrl
            changeRequest.commitChanges { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: Data())
                }
            }
        }
    }
    
    static func fetchFromDatabase(withId id: String) async throws -> UserDatabase {
        guard let dbRef = FirebaseDatabase.shared.databaseRef else {
            throw NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get database reference"])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            dbRef.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? NSDictionary else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch data"]))
                    return
                }
                
                if let user = UserDatabase.fromNSDictionary(value) {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse data"]))
                }
            }
        }
    }
    
}
