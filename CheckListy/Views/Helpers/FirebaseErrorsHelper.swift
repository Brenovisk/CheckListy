//
//  FirebaseErrorsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Firebase
import Foundation

enum FirebaseErrorsHelper: String, CaseIterable {
    case invalidCustomToken = "17000"
    case customTokenMismatch = "17002"
    case invalidCredential = "17004"
    case userDisabled = "17005"
    case operationNotAllowed = "17006"
    case emailAlreadyInUse = "17007"
    case invalidEmail = "17008"
    case wrongPassword = "17009"
    case tooManyRequests = "17010"
    case userNotFound = "17011"
    case accountExistsWithDifferentCredential = "17012"
    case requiresRecentLogin = "17014"
    case providerAlreadyLinked = "17015"
    case noSuchProvider = "17016"
    case invalidUserToken = "17017"
    case userTokenExpired = "17021"
    case userInfoNameKey = "17058"
    case userNoResgisteredInEnvironment = "17085"
    case errorUserInfoNameKey = "17034"
}

extension FirebaseErrorsHelper {
    var value: FirebaseAuthError {
        switch self {
        case .invalidCustomToken:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.invalidCustomToken.rawValue)
        case .customTokenMismatch:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.customTokenMismatch.rawValue)
        case .invalidCredential:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.invalidCredential.rawValue)
        case .userDisabled:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.userDisabled.rawValue)
        case .operationNotAllowed:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.operationNotAllowed.rawValue)
        case .emailAlreadyInUse:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.emailAlreadyInUse.rawValue)
        case .invalidEmail:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.invalidEmail.rawValue)
        case .wrongPassword:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.wrongPassword.rawValue)
        case .tooManyRequests:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.tooManyRequests.rawValue)
        case .userNotFound:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.userNotFound.rawValue)
        case .accountExistsWithDifferentCredential:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.accountExistsDifferentCredential.rawValue)
        case .requiresRecentLogin:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.requiresRecentLogin.rawValue)
        case .providerAlreadyLinked:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.providerAlreadyLinked.rawValue)
        case .noSuchProvider:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.noSuchProvider.rawValue)
        case .invalidUserToken:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.invalidUserToken.rawValue)
        case .userTokenExpired:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.userTokenExpired.rawValue)
        case .userInfoNameKey:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.genericError.rawValue)
        case .userNoResgisteredInEnvironment:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.interactionCancelledByUser.rawValue)
        case .errorUserInfoNameKey:
            return FirebaseAuthError(code: rawValue, description: TextsHelper.noUserRegisteredWithThisNumber.rawValue)
        }
    }

    static func getDescription(to error: Error) -> String {
        let defaultError = TextsHelper.genericError.rawValue

        guard let codeError = (error as? AuthErrorCode)?.errorCode,
              let firebaseError = FirebaseErrorsHelper(rawValue: String(codeError))?.value.description
        else {
            return defaultError
        }

        return firebaseError
    }
}

struct FirebaseAuthError {
    var code: String
    var description: String
}
