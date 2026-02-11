//
//  UserRepository.swift
//  CheckListy
//

import Foundation
import Firebase

class UserRepository: UserRepositoryProtocol {
    
    private let firebaseDatabase: FirebaseDatabase
    private let localImageDataSource: LocalImageDataSource
    private let remoteImageDataSource: RemoteImageDataSource
    
    init(
        firebaseDatabase: FirebaseDatabase,
        localImageDataSource: LocalImageDataSource,
        remoteImageDataSource: RemoteImageDataSource
    ) {
        self.firebaseDatabase = firebaseDatabase
        self.localImageDataSource = localImageDataSource
        self.remoteImageDataSource = remoteImageDataSource
    }
    
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
        _ = try await remoteImageDataSource.upload(imageData: imageData, userId: userId)
    }
    
    func getProfileImageData(userId: String) async throws -> Data? {
        if let localData = localImageDataSource.load(withName: "profile_\(userId).jpg") {
            return localData
        }
        
        do {
            let remoteData = try await remoteImageDataSource.download(userId: userId)
            try? localImageDataSource.save(imageData: remoteData, withName: "profile_\(userId).jpg")
            return remoteData
        } catch {
            return nil
        }
    }
}
