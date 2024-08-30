//
//  Array+toNSDictionary.swift
//  CheckListy
//
//  Created by Breno Lucas on 29/08/24.
//

import Foundation

extension Array where Element == String {

    func toNSDictionary(withDefaultValue _: Any = true) -> NSDictionary {
        let dictionary = NSMutableDictionary()

        for (index, element) in enumerated() {
            dictionary[String(index)] = element
        }

        return dictionary
    }

}
