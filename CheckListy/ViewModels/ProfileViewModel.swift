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

    @Published var isLoading: Bool = false
    @Published var userDatabase: UserDatabase?
    @Published var dataForm: DataFormDeleteAccount = .init()
    @Published var showPopup: Bool = false
    @Published private(set) var popupData: PopupData = .init()

    @MainActor
    func getUserDatabase() async {
        do {
            isLoading = true
            let user = try getAuthUser()
            let userManager = UserManager(authUser: user)

            userDatabase = try await CheckListy.UserDatabase(
                id: user.uid,
                name: userManager.getName(),
                urlProfileImage: userManager.getUrlProfileImage(),
                lists: userManager.getList(), profileImage: userManager.getImage(),
                email: userManager.getEmail()
            )

            isLoading = false
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
            isLoading = false
        }
    }

    func update(user: UserDatabase) async throws {
        do {
            isLoading = true
            guard hasChangeData(of: user) else { return }
            try await updateNameIfNeeded(user)
            try await updateImageIfNeeded(user)
            await getUserDatabase()
            isLoading = false
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
            isLoading = false
        }
    }

    func update(_ oldPassword: String, to newPassword: String) async throws {
        do {
            isLoading = true
            let userManager = try await getUserManager()
            guard !newPassword.isEmpty, !oldPassword.isEmpty else { return }
            try await userManager.update(oldPassword: oldPassword, to: newPassword)
            isLoading = false
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
            isLoading = false
        }
    }

    func hasChangeData(of user: UserDatabase) -> Bool {
        user.name != userDatabase?.name || user.profileImage != userDatabase?.profileImage
    }

    @MainActor
    func signOut() {
        do {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UserDefaultsService.clearAll()
                FirebaseDatabase.shared.clearData()
            }
            isLoading = false
            try FirebaseAuthService.shared.signOut()
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
            isLoading = false
        }
    }

    @MainActor
    func removeUserData() {
        Task {
            do {
                isLoading = true
                let userManager = try getUserManager()
                try await userManager.removeUserData(with: dataForm.password)
                isLoading = false
                signOut()
            } catch {
                let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
                setPopupDataError(with: errorMessage)
                isLoading = false
            }
        }
    }

    func navigateToDeleteAccountView() {
        NavigationService.shared.navigateTo(.deleteAccountView)
    }

}

extension ProfileViewModel {

    @MainActor
    private func updateNameIfNeeded(_ user: UserDatabase) async throws {
        if user.name != userDatabase?.name {
            let userManager = try getUserManager()
            try await userManager.update(name: user.name, of: user)
            await getUserDatabase()
        }
    }

    @MainActor
    private func updateImageIfNeeded(_ user: UserDatabase) async throws {
        if let image = user.profileImage, image != userDatabase?.profileImage {
            try await UserManager.uploadProfile(image, for: user)
            await getUserDatabase()
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

    private func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}
