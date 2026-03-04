//
//  UserRepositoryProtocol.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchUser(userId: String) async throws -> UserProfile
    func saveUser(_ user: UserProfile) async throws
    func saveProfileImage(imageData: Data, userId: String) async throws
    func getProfileImageData(userId: String) async throws -> Data?
    func updateLists(ids: [String], userId: String)
}
