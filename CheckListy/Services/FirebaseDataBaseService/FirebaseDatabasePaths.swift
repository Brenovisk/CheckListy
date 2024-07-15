//
//  FirebaseDatabasePaths.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation

enum FirebaseDatabasePaths: CustomStringConvertible {
    
    case lists
    
}

extension FirebaseDatabasePaths {
    
    var description: String {
        switch self {
        case .lists:
            return "lists"
        }
    }
    
}
