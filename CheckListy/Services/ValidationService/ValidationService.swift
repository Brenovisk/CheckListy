//
//  ValidationService.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation

class ValidationService {
    
    static func validate(value: String, with validators: [Validators]) -> String? {
        for validator in validators {
            if let error = validator.value.validate(value) {
                return error
            }
        }
        return nil
    }
    
}

enum Validators {
    
    case requiredValidator
    case passwordValidator
    case emailValidator
    case maxCountValidator
    case noEqualValues(firstValue: String)
    
}

extension Validators {
    
    var value: Validator {
        switch self {
        case .requiredValidator:
            return RequiredValidator(errorMessage: TextsHelper.requiredField.rawValue)
        case .passwordValidator:
            return PasswordValidator(errorMessage: TextsHelper.passwordMinLength.rawValue)
        case .emailValidator:
            return EmailValidator(errorMessage: TextsHelper.emailInvalid.rawValue) 
        case .maxCountValidator:
            return MaxCountValidator(errorMessage: TextsHelper.exceededMaxLimit.rawValue, maxLimit: 20)
        case .noEqualValues(let firstValue):
            return NoEqualValuesValidator(errorMessage: TextsHelper.differentValuesPassword.rawValue, firstValue: firstValue)
        }
    }
    
}
