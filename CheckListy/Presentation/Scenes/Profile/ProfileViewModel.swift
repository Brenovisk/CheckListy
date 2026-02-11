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
    
    private let router: AppRouter
    private let authService: FirebaseAuthService
    private let userRepository: UserRepositoryProtocol
    
    init(router: AppRouter, authService: FirebaseAuthService, userRepository: UserRepositoryProtocol) {
        self.router = router
        self.authService = authService
        self.userRepository = userRepository
    }

    @MainActor
    func getUserDatabase() async {
        do {
            isLoading = true
            let user = try getAuthUser()
            
            // Get Name
            var name = UserDefaultsService.loadItem(.userName)
            if name.isEmpty {
                name = user.displayName ?? ""
                UserDefaultsService.add(.userName, name)
            }
            
            // Get Image
            var image: UIImage?
            if let data = try await userRepository.getProfileImageData(userId: user.uid) {
                image = UIImage(data: data)
            }
            
            // Get Lists (from user profile)
            let userProfile = try await userRepository.fetchUser(userId: user.uid)
            let lists = userProfile.lists

            userDatabase = try await CheckListy.UserDatabase(
                id: user.uid,
                name: name,
                urlProfileImage: nil, // Local only
                lists: lists,
                profileImage: image,
                email: try UserService.getEmail(of: user)
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
            
            let authUser = try getAuthUser()
            
            // Update Name
            if user.name != userDatabase?.name {
                try await UserService.update(authUser, displayName: user.name)
                // Update UserProfile in Repo
                // We need to fetch current profile to keep other fields or just update known ones?
                // Domain UserProfile: id, name, email, lists
                // We have user.lists from input.
                let userProfile = UserProfile(
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    lists: user.lists
                )
                try await userRepository.saveUser(userProfile)
            }
            
            // Update Image
            if let image = user.profileImage, image != userDatabase?.profileImage {
                if let data = image.jpegData(compressionQuality: 0.8) {
                    try await userRepository.saveProfileImage(imageData: data, userId: user.id)
                }
            }
            
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
            let authUser = try getAuthUser()
            guard !newPassword.isEmpty, !oldPassword.isEmpty else { return }
            try await UserService.update(authUser, oldPassword: oldPassword, to: newPassword)
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
            UserDefaultsService.clearAll()
            try authService.signOut()
            deleteDocumentsDirectory()
        } catch {
            let errorMessage = FirebaseErrorsHelper.getDescription(to: error)
            setPopupDataError(with: errorMessage)
        }
    }

    func deleteDocumentsDirectory() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        try? FileManager.default.removeItem(at: documentsDirectory)
    }

    @MainActor
    func removeUserData() {
        Task {
            do {
                isLoading = true
                let authUser = try getAuthUser()
                
                try await UserService.reauthtenticateWithFirebaseAuth(authUser, with: dataForm.password)
                try await UserService.removeLists(of: authUser)
                // Remove local image? Repo doesn't have delete. Skipping or add delete to repo later.
                
                try await UserService.removeFromDataBase(authUser)
                try await UserService.removeFromFirebaseAuth(authUser)
                
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
        router.navigate(to: .deleteAccount)
    }

}

extension ProfileViewModel {

    @MainActor
    private func getAuthUser() throws -> User {
        try authService.getAuthUser()
    }

    private func setPopupDataError(with message: String) {
        popupData = PopupData(
            type: .error,
            message: message
        )
        showPopup = true
    }

}
