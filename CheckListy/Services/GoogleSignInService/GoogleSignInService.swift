//
//  GoogleSignInService.swift
//  CheckListy
//
//  Created by Breno Lucas on 06/11/24.
//

import Firebase
import Foundation
import GoogleSignIn

class GoogleSignInService {

    static func signIn() async throws -> User? {
        // Get app client id
        guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Sign In method
        let result: GIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationHelper.rootViewController)

        let credential = GoogleAuthProvider.credential(
            withIDToken: result.user.idToken?.tokenString ?? String(),
            accessToken: result.user.accessToken.tokenString
        )

        let authDataResult = try await Auth.auth().signIn(with: credential)
        debugPrint(authDataResult.user)

        return authDataResult.user
    }

}
