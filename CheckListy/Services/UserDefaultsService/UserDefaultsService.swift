//
//  File.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/07/24.
//

import Foundation

class UserDefaultsService {
    
    static func save(_ key: Keys, _ array: [String]) {
        UserDefaults.standard.set(array, forKey: key.rawValue)
    }
    
    static func load(_ key: Keys) -> [String] {
        return UserDefaults.standard.stringArray(forKey: key.rawValue) ?? []
    }
    
    static func addItem(key: Keys, _ item: String) {
        var currentArray = load(key)
        currentArray.append(item)
        save(key, currentArray)
    }
    
    static func removeItem(key: Keys, _ item: String) {
        var currentArray = load(key)
        currentArray.removeAll { $0 == item }
        save(key, currentArray)
    }
}

extension UserDefaultsService {
    
    typealias Keys = UserDefaultsServiceKeys
}
