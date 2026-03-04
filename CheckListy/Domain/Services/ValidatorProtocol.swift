//
//  ValidatorProtocol.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/08/24.
//

import Foundation

protocol Validator {

    func validate(_ value: String) -> String?
    var errorMessage: String? { get }

}
