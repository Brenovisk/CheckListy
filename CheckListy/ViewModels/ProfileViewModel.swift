//
//  ProfileViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    
    @Published var userProfile: UserProfile?
    
    @MainActor
    func getUserProfile() async {
        do {
            let id = getUserId()
            let email = getUserEmail()
            let image = await getUserImage()
            let user = try await UserService.fetchFromDatabase(withId: id)
            
            self.userProfile = UserProfile(
                id: id,
                name: user.name,
                urlProfileImage: user.urlProfileImage,
                profileImage: image,
                email: email
            )
        } catch {
            debugPrint(error)
        }
    }
    
    func update(user: UserProfile) async throws {
        do {
            guard hasChangeData(of: user) else { return }
            try await updateNameIfNeeded(user)
            try await updateImageIfNeeded(user)
            try await user.saveToDatabase()
            await getUserProfile()
        } catch {
            debugPrint(error)
        }
    }
    
    func hasChangeData(of user: UserProfile) -> Bool {
        user.name != userProfile?.name || user.profileImage != userProfile?.profileImage
    }
    
}

extension ProfileViewModel {
    
    @MainActor
    private func getUserName() -> String {
        FirebaseAuthService.shared.getAuthUserName()
    }
    
    @MainActor
    private func getUserImage() async -> UIImage? {
        await FirebaseAuthService.shared.getAuthUserImage()
    }
    
    @MainActor
    private func getUserEmail() -> String {
        FirebaseAuthService.shared.getAuthUserEmail()
    }
    
    @MainActor
    private func getUserId() -> String {
        FirebaseAuthService.shared.getAuthUserId()
    }
    
    @MainActor
    private func updateNameIfNeeded(_ user: UserProfile) async throws {
        if user.name != userProfile?.name {
            try await UserManager.updateFirebaseUser(name: user.name)
            FirebaseAuthService.shared.authUserName = user.name
        }
    }
    
    @MainActor
    private func updateImageIfNeeded(_ user: UserProfile) async throws {
        if let image = user.profileImage, image != userProfile?.profileImage  {
            try await UserManager.uploadProfileImage(image, forUser: user)
            FirebaseAuthService.shared.authUserImage = user.profileImage
        }
    }
    
}
