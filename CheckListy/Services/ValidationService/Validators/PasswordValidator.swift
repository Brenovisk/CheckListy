//
//  PasswordValidator.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/08/24.
//

import Foundation

struct PasswordValidator: Validator {
    
    var errorMessage: String?
    var defaultErrorMessage = "Password must be at least 6 characters"
    
    func validate(_ value: String) -> String? {
        value.count >= 6 ? nil : (errorMessage ?? defaultErrorMessage)
    }
    
}
