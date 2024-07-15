//
//  FirebaseAuthService.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Combine
import Firebase

@MainActor
class FirebaseAuthService: ObservableObject {
    
    static let shared = FirebaseAuthService()
    @Published var isSignIn: Bool?
    
    private init() {
        addListenerUserState()
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            debugPrint(authDataResult)
            self.isSignIn = true
        } catch {
            throw error
        }
    }
    
    func signUp(withEmail email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            debugPrint(authDataResult)
        } catch {
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            self.isSignIn = false
        } catch {
            throw error
        }
    }
    
    private func addListenerUserState() {
        guard let app = FirebaseApp.app() else { return }
        
        Auth.auth(app: app).addStateDidChangeListener { auth, user in
            Task { @MainActor in
                self.isSignIn = (user != nil)
            }
        }
    }
}
