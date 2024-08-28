//
//  DataFormSignIn.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation

struct DataFormSignIn {
    var email: String = .init()
    var password: String = .init()

    var emailError: String?
    var passwordError: String?

    mutating func isValid() -> Bool {
        emailError = ValidationService.validate(value: email, with: [.requiredValidator, .emailValidator])
        passwordError = ValidationService.validate(value: password, with: [.requiredValidator, .passwordValidator])
        return [emailError, passwordError].allSatisfy { $0 == nil }
    }

    mutating func resetErrors() {
        emailError = nil
        passwordError = nil
    }
}
