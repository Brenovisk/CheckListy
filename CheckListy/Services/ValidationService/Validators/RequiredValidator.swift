//
//  RequiredValidator.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/08/24.
//

import Foundation

struct RequiredValidator: Validator {
    
    var errorMessage: String?
    var defaultErrorMessage = "This field cannot be empty"
    
    func validate(_ value: String) -> String? {
        !value.isEmpty ? nil : (errorMessage ?? defaultErrorMessage)
    }
    
}
