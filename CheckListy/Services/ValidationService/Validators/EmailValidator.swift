//
//  EmailValidator.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/08/24.
//

import Foundation

struct EmailValidator: Validator {
    
    var errorMessage: String?
    var defaultErrorMessage = "Invalid email address"
    
    func validate(_ value: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: value) ? nil : (errorMessage ?? defaultErrorMessage)
    }
}
