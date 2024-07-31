//
//  FirebaseAuthService.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Combine
import Firebase
import FirebaseStorage
import FirebaseFirestore
import UIKit

@MainActor
class FirebaseAuthService: ObservableObject {
    
    static let shared = FirebaseAuthService()
    
    var auth: Auth = Auth.auth()
    
    var authUserImage: UIImage? {
        get { UserDefaultsService.loadImage(.userProfileImage) }
        set { UserDefaultsService.addImage(.userProfileImage, newValue) }
    }
    
    var authUserName: String? {
        get { UserDefaultsService.loadItem(.userName) }
        set { UserDefaultsService.add(.userName, newValue) }
    }
    
    @Published var isSignIn: Bool?
    @Published var isEnable: Bool = true
    
    private init() {
        addListenerUserState()
    }
    
    @MainActor
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            debugPrint(authDataResult)
            self.isSignIn = true
        } catch {
            throw error
        }
    }
    
    @MainActor
    func signUp(withEmail email: String, password: String, name: String, uiImage: UIImage?, completion: (Bool) -> Void) async throws {
        do {
            isEnable = false
            let authDataResult = try await auth.createUser(withEmail: email, password: password)
            try await saveInDataBase(newUser: authDataResult.user, with: name, image: uiImage)
            updateAuthUser(name, uiImage)
            completion(false)
            isEnable = true
        } catch {
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try auth.signOut()
            self.isSignIn = false
        } catch {
            throw error
        }
    }
    
    @MainActor
    func getAuthUser() -> User? {
        auth.currentUser
    }
    
    @MainActor
    func getAuthUserId() -> String {
        auth.currentUser?.uid ?? String()
    }
    
    @MainActor
    func getAuthUserName() -> String {
        if let name = self.authUserName, !name.isEmpty {
            return name
        }
        
        let name = auth.currentUser?.displayName ?? String()
        updateAuthUser(name)
        return name
    }
    
    @MainActor
    func getAuthUserImage() async -> UIImage? {
        if let userImage = self.authUserImage {
            return userImage
        }
        
        do {
            let userId = self.getAuthUserId()
            let image = try await UserManager.fetchProfileImage(forUserId: userId)
            updateAuthUser(String(), image)
            return image
        } catch {
            return nil
        }
    }
    
}

// MARK: - Helper methods
extension FirebaseAuthService {
    
    private func addListenerUserState() {
        guard let app = FirebaseApp.app() else { return }
        
        Auth.auth(app: app).addStateDidChangeListener { auth, user in
            Task { @MainActor in
                self.isSignIn = (user != nil)
            }
        }
    }
    
    private func saveInDataBase(newUser: User, with name: String, image: UIImage? ) async throws {
        guard let user = getAuthUser() else {
            throw NSError(domain: "no User", code: -1, userInfo: nil)
        }
        
        let userDb = UserDatabase(id: user.uid, name: name, urlProfileImage: URL(string: String()))
        try await userDb.saveToDatabase()
        try await UserManager.updateFirebaseUser(name: name)
        
        guard let image else { return }
        try await UserManager.uploadProfileImage(image, forUser: userDb)
    }
    
    private func updateAuthUser(_ name: String = String(), _ image: UIImage? = nil) {
        if !name.isEmpty {
            self.authUserName = name
        }
        
        guard let image else { return }
        self.authUserImage = image
    }
    
}
