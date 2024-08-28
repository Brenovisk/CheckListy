//
//  ProfileViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Firebase
import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?

    @MainActor
    func getUserProfile() async {
        do {
            let user = try getAuthUser()
            let userManager = UserManager(authUser: user)

            userProfile = try await UserProfile(
                id: user.uid,
                name: userManager.getName(),
                urlProfileImage: userManager.getUrlProfileImage(),
                profileImage: userManager.getImage(),
                email: userManager.getEmail()
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
            await getUserProfile()
        } catch {
            debugPrint(error)
        }
    }

    func update(_ oldPassword: String, to newPassword: String) async throws {
        do {
            let userManager = try await getUserManager()
            guard !newPassword.isEmpty, !oldPassword.isEmpty else { return }
            try await userManager.update(oldPassword: oldPassword, to: newPassword)
        } catch {
            debugPrint(error)
        }
    }

    func hasChangeData(of user: UserProfile) -> Bool {
        user.name != userProfile?.name || user.profileImage != userProfile?.profileImage
    }

    @MainActor
    func signOut() {
        do {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                FirebaseDatabase.shared.removeListeners()
                UserDefaultsService.clearAll()
                FirebaseDatabase.shared.clearData()
            }

            try FirebaseAuthService.shared.signOut()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func removeUserData() {
        Task {
            do {
                let userManager = try await getUserManager()
                try await userManager.removeUserData()
                await signOut()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}

extension ProfileViewModel {
    @MainActor
    private func updateNameIfNeeded(_ user: UserProfile) async throws {
        if user.name != userProfile?.name {
            let userManager = try getUserManager()
            try await userManager.update(name: user.name)
            await getUserProfile()
        }
    }

    @MainActor
    private func updateImageIfNeeded(_ user: UserProfile) async throws {
        if let image = user.profileImage, image != userProfile?.profileImage {
            try await UserManager.uploadProfile(image, for: user)
            await getUserProfile()
        }
    }

    @MainActor
    private func getUserManager() throws -> UserManager {
        let user = try getAuthUser()
        return UserManager(authUser: user)
    }

    @MainActor
    private func getAuthUser() throws -> User {
        try FirebaseAuthService.shared.getAuthUser()
    }
}
