//
//  ImageService.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import FirebaseStorage
import Foundation
import UIKit

class ImageService {
    static func convertImageToData(_ image: UIImage) throws -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageConversionError", code: -1, userInfo: nil)
        }
        return imageData
    }

    static func uploadImageData(_ data: Data, for userId: String) async throws -> URL {
        let storageRef = Storage.storage().reference().child("profile_images").child("\(userId).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let _: StorageMetadata? = try await withCheckedThrowingContinuation { continuation in
            storageRef.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: metadata)
                }
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            storageRef.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: NSError(domain: "DownloadURLError", code: -1, userInfo: nil))
                }
            }
        }
    }

    static func downloadImage(fromURL url: URL) async throws -> Data {
        let storageRef = Storage.storage().reference(forURL: url.absoluteString)
        return try await withCheckedThrowingContinuation { continuation in
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: NSError(domain: "ImageDataError", code: -1, userInfo: nil))
                }
            }
        }
    }

    static func deletePhoto(name: String) async throws {
        let storageRef = Storage.storage().reference().child("profile_images").child("\(name).jpg")

        let _: () = try await withCheckedThrowingContinuation { continuation in
            storageRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    static func convertToUImage(from imageData: Data) throws -> UIImage {
        guard let image = UIImage(data: imageData) else {
            throw NSError(domain: "ImageDataError", code: -1, userInfo: nil)
        }

        return image
    }
}
