//
//  String+RemoveWhiteSpaces.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation

extension String {
    func removeWhiteSpaces() -> String {
        trimmingCharacters(in: .whitespaces)
    }
}
