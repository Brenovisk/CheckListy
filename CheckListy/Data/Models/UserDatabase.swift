//
//  UserDatabase.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation
import UIKit

struct UserDatabase: ConvertibleDictionary {

    var id: String
    var name: String
    var urlProfileImage: URL?
    var lists: [String] = []
    var profileImage: UIImage?
    var email: String = .init()

}

extension UserDatabase {

    func toNSDictionary() -> NSDictionary {
        [
            "id": id,
            "name": name,
            "urlProfileImage": urlProfileImage?.absoluteString ?? String(),
            "lists": lists
        ] as NSDictionary
    }

    static func fromNSDictionary(_ dictionary: NSDictionary) -> UserDatabase? {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let urlString = dictionary["urlProfileImage"] as? String
        else {
            return nil
        }

        let urlProfileImage = URL(string: urlString)
        let lists = (dictionary["lists"] as? [String]) ?? []

        return UserDatabase(
            id: id,
            name: name,
            urlProfileImage: urlProfileImage,
            lists: lists
        )
    }

    func saveToDatabase() async throws {
        guard let dbRef = FirebaseDatabase.shared.databaseRef else {
            throw NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get database reference"])
        }

        let userDict = toNSDictionary()

        let _: () = try await withCheckedThrowingContinuation { continuation in
            dbRef.child("users").child(self.id).setValue(userDict) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

}
