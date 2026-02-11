//
//  RemoteImageDataSource.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation
import FirebaseStorage

class RemoteImageDataSource {
    
    static let shared = RemoteImageDataSource()
    private let storage = Storage.storage()
    
    func upload(imageData: Data, userId: String) async throws -> URL {
        let ref = storage.reference().child("profile_images/\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _: StorageMetadata = try await withCheckedThrowingContinuation { continuation in
            ref.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let metadata = metadata {
                    continuation.resume(returning: metadata)
                }
            }
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            ref.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: NSError(domain: "DownloadURLError", code: -1))
                }
            }
        }
    }
    
    func download(userId: String) async throws -> Data {
        let ref = storage.reference().child("profile_images/\(userId).jpg")
        return try await withCheckedThrowingContinuation { continuation in
            ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: NSError(domain: "DownloadError", code: -1))
                }
            }
        }
    }
    
    func delete(userId: String) async throws {
        let ref = storage.reference().child("profile_images/\(userId).jpg")
        try await withCheckedThrowingContinuation { continuation in
            ref.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
