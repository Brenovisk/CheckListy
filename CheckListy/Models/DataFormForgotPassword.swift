//
//  DataFormForgotPassword.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import Foundation

struct DataFormForgotPassword {

    var email: String = .init()
    var emailError: String?

    mutating func isValid() -> Bool {
        emailError = ValidationService.validate(value: email, with: [.requiredValidator, .emailValidator])
        return [emailError].allSatisfy { $0 == nil }
    }

    mutating func resetErrors() {
        emailError = nil
    }

}
