//
//  DataFormSignUp.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/08/24.
//

import Foundation
import UIKit

struct DataFormSignUp {
    
    var name: String = String()
    var email: String = String()
    var password: String = String()
    var confirmationPassword: String = String()
    var uiImage: UIImage? = nil
    
    var nameError: String? = nil
    var emailError: String? = nil
    var passwordError: String? = nil
    var confirmationPasswordError: String? = nil
    
    mutating func isValidEmailAndName() -> Bool {
        nameError = ValidationService.validate(
            value: name,
            with: [.requiredValidator,.maxCountValidator]
        )
        
        emailError = ValidationService.validate(
            value: email,
            with: [.requiredValidator,.emailValidator]
        )
        
        return [nameError, emailError].allSatisfy { $0 == nil }
    }
    
    mutating func isValidPasswordAndConfirmation() -> Bool {
        passwordError = ValidationService.validate(
            value: password,
            with: [.requiredValidator,.passwordValidator]
        )
        
        confirmationPasswordError = ValidationService.validate(
            value: confirmationPassword,
            with: [.requiredValidator,.noEqualValues(firstValue: password)]
        )
        
        return [passwordError, confirmationPasswordError].allSatisfy { $0 == nil }
    }

    
    mutating func resetErrors() {
        nameError = nil
        emailError = nil
        passwordError = nil
        confirmationPasswordError = nil
    }
    
}
