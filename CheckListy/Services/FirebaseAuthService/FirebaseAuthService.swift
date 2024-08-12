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
        } catch {
            throw error
        }
    }
    
    @MainActor
    func signUp(withEmail email: String, password: String, name: String, uiImage: UIImage?, completion: (Bool) -> Void) async throws {
        do {
            isEnable = false
            let authDataResult = try await auth.createUser(withEmail: email, password: password)
            let manager = UserManager(authUser: authDataResult.user)
            try await manager.storeDataBase(with: name, and: uiImage)
            completion(false)
            isEnable = true
        } catch {
            throw error
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
            self.isSignIn = false
        } catch {
            throw error
        }
    }
    
    func getAuthUser() throws -> User {
        guard let user = auth.currentUser else {
           throw NSError(domain: "no User", code: -1, userInfo: nil)
       }
       
        return user
    }
    
    func deleteAuthUser(_ user: User) async throws {
        try await user.delete()
    }
    
}

// MARK: - Helper methods
extension FirebaseAuthService {
    
    private func addListenerUserState() {
        guard let app = FirebaseApp.app() else { return }
        
        Auth.auth(app: app).addStateDidChangeListener { auth, user in
            Task { @MainActor in
                if user != nil {
                    NavigationService.shared.resetNavigation()
                } else {
                    NavigationService.shared.resetNavigationAuth()
                }
                
                self.isSignIn = (user != nil)
            }
        }
    }
    
}
