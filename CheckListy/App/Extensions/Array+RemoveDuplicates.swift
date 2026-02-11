//
//  Array+RemoveDuplicates.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/07/24.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()

        return filter { element in
            guard !seen.contains(element) else { return false }
            seen.insert(element)
            return true
        }
    }

    mutating func removeDuplicates() {
        self = removingDuplicates()
    }
}
