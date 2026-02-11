//
//  LocalImageDataSource.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation

class LocalImageDataSource {
    
    static let shared = LocalImageDataSource()
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func save(imageData: Data, withName name: String) throws {
        guard let url = documentsDirectory?.appendingPathComponent(name) else { return }
        try imageData.write(to: url)
    }
    
    func load(withName name: String) -> Data? {
        guard let url = documentsDirectory?.appendingPathComponent(name) else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func delete(withName name: String) throws {
        guard let url = documentsDirectory?.appendingPathComponent(name) else { return }
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
}
