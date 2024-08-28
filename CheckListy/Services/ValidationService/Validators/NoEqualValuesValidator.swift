//
//  NoEqualValuesValidator.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/08/24.
//

import Foundation

struct NoEqualValuesValidator: Validator {
    var errorMessage: String?
    var firstValue: String
    var defaultErrorMessage = "The values ​​are different"

    func validate(_ value: String) -> String? {
        firstValue == value ? nil : (errorMessage ?? defaultErrorMessage)
    }
}
