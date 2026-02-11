//
//  UserRepository.swift
//  CheckListy
//

import Foundation
import Firebase

class UserRepository: UserRepositoryProtocol {
    
    private let firebaseDatabase = FirebaseDatabase.shared
    private let localImageDataSource = LocalImageDataSource.shared
    
    func fetchUser(userId: String) async throws -> UserProfile {
        let dictionary: NSDictionary = try await firebaseDatabase.getData(from: .users, with: userId)
        guard let user = UserDTO.toDomain(dictionary) else {
            throw NSError(domain: "UserMappingError", code: -1)
        }
        return user
    }
    
    func saveUser(_ user: UserProfile) async throws {
        let path = "\(FirebaseDatabasePaths.users.description)/\(user.id)"
        firebaseDatabase.update(path: path, data: UserDTO.fromDomain(user))
    }
    
    func saveProfileImage(imageData: Data, userId: String) async throws {
        try localImageDataSource.save(imageData: imageData, withName: "profile_\(userId).jpg")
    }
    
    func getProfileImageData(userId: String) async throws -> Data? {
        return localImageDataSource.load(withName: "profile_\(userId).jpg")
    }
}
