//
//  DataFormDeleteAccount.swift
//  CheckListy
//
//  Created by Breno Lucas on 29/08/24.
//

import Foundation

struct DataFormDeleteAccount {

    var password: String = .init()
    var passwordError: String?

    mutating func isValid() -> Bool {
        passwordError = ValidationService.validate(value: password, with: [.requiredValidator, .passwordValidator])
        return [passwordError].allSatisfy { $0 == nil }
    }

    mutating func resetErrors() {
        passwordError = nil
    }

}
