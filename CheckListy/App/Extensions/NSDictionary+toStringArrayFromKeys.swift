//
//  NSDictionary+toStringArrayFromKeys.swift
//  CheckListy
//
//  Created by Breno Lucas on 29/08/24.
//

import Foundation

extension NSDictionary {

    func toStringArrayFromKeys() -> [String] {
        allKeys.compactMap { $0 as? String }
    }

}
