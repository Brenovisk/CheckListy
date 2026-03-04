//
//  DataFormSignUp.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/08/24.
//

import Foundation
import UIKit

struct DataFormSignUp {
    var name: String = .init()
    var email: String = .init()
    var password: String = .init()
    var confirmationPassword: String = .init()
    var uiImage: UIImage?

    var nameError: String?
    var emailError: String?
    var passwordError: String?
    var confirmationPasswordError: String?

    mutating func isValidEmailAndName() -> Bool {
        nameError = ValidationService.validate(
            value: name,
            with: [.requiredValidator, .maxCountValidator]
        )

        emailError = ValidationService.validate(
            value: email,
            with: [.requiredValidator, .emailValidator]
        )

        return [nameError, emailError].allSatisfy { $0 == nil }
    }

    mutating func isValidPasswordAndConfirmation() -> Bool {
        passwordError = ValidationService.validate(
            value: password,
            with: [.requiredValidator, .passwordValidator]
        )

        confirmationPasswordError = ValidationService.validate(
            value: confirmationPassword,
            with: [.requiredValidator, .noEqualValues(firstValue: password)]
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
