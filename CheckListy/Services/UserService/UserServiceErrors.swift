//
//  UserServiceErrors.swift
//  CheckListy
//
//  Created by Breno Lucas on 05/08/24.
//

import Foundation

enum UserServiceErrors: Error {
    
    case noAuthenticatedUser
    case unableToGetDatabaseReference
    case dataFetchError
    case dataParseError
    case imageConversionError
    case imageDownloadError
    case imageDataError
    case userNotFoundError
    case passwordUpdateError
    case urlError
    case databaseError(String)
    case unknownError
    case updateError(String)
    case userNotFound
    
}

extension UserServiceErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noAuthenticatedUser:
            return "No authenticated user found."
        case .unableToGetDatabaseReference:
            return "Unable to get database reference."
        case .dataFetchError:
            return "Unable to fetch data."
        case .dataParseError:
            return "Unable to parse data."
        case .imageConversionError:
            return "Image conversion error."
        case .imageDownloadError:
            return "Image download error."
        case .imageDataError:
            return "Invalid image data."
        case .userNotFoundError:
            return "User not found."
        case .passwordUpdateError:
            return "Password update error."
        case .urlError:
            return "Invalid URL."
        case .databaseError(let message):
            return message
        case .unknownError:
            return "Unknown error."
        case .userNotFound:
            return "No authenticated user found."
        case .updateError(let message):
            return message
        }
    }
}


