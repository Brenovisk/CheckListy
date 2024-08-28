//
//  MaxCountValidator.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/08/24.
//

import Foundation

struct MaxCountValidator: Validator {
    var errorMessage: String?
    var maxLimit: Int

    var defaultErrorMessage: String {
        "Must be at most \(maxLimit) caracters"
    }

    func validate(_ value: String) -> String? {
        value.count <= maxLimit ? nil : (errorMessage ?? defaultErrorMessage)
    }
}
