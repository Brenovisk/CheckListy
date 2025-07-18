//
//  NSDictionary+toStringArrayFromValues.swift
//  CheckListy
//
//  Created by Breno Lucas on 29/08/24.
//

import Foundation

extension NSDictionary {

    func toStringArrayFromValues() -> [String] {
        allValues.compactMap { $0 as? String }
    }

}
