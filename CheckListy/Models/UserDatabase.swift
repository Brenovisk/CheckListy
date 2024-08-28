//
//  UserDatabase.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation

class UserDatabase: ConvertibleDictionary {
    var id: String
    var name: String
    var urlProfileImage: URL?

    required init(id: String, name: String, urlProfileImage: URL?) {
        self.id = id
        self.name = name
        self.urlProfileImage = urlProfileImage
    }
}

extension UserDatabase {
    func toNSDictionary() -> NSDictionary {
        return [
            "id": id,
            "name": name,
            "urlProfileImage": urlProfileImage?.absoluteString ?? String()
        ] as NSDictionary
    }

    static func fromNSDictionary(_ dictionary: NSDictionary) -> Self? {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let urlString = dictionary["urlProfileImage"] as? String
        else {
            return nil
        }

        let urlProfileImage = URL(string: urlString)

        return Self(id: id, name: name, urlProfileImage: urlProfileImage)
    }
}

extension UserDatabase {
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
