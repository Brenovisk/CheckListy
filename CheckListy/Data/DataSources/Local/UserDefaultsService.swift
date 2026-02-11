//
//  UserDefaultsService.swift
//  CheckListy
//
//  Created by Breno Lucas on 23/07/24.
//

import Foundation
import UIKit

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

    static func loadItem(_ key: Keys) -> String {
        var _ = load(key)
        let items = load(key)
        return items.isEmpty ? String() : items[0]
    }

    static func removeItem(key: Keys, _ item: String) {
        var currentArray = load(key)
        currentArray.removeAll { $0 == item }
        save(key, currentArray)
    }

    static func add<T: Codable>(_ key: Keys, _ object: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
    }

    static func load<T: Codable>(_ key: Keys, as type: T.Type) -> T? {
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            return try? decoder.decode(type, from: data)
        }
        return nil
    }

    static func load<T: Codable>(_ key: Keys, asArrayOf _: T.Type) -> [T] {
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            return (try? decoder.decode([T].self, from: data)) ?? []
        }
        return []
    }

    static func addImage(_ key: Keys, _ image: UIImage?) {
        if let image, let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: key.rawValue)
        }
    }

    static func loadImage(_ key: Keys) -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: key.rawValue) {
            return UIImage(data: imageData)
        }
        return nil
    }

    static func removeImage(_ key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }

    static func clearAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}

extension UserDefaultsService {
    typealias Keys = UserDefaultsServiceKeys
}
