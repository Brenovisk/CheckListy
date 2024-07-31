//
//  UserDatabase.swift
//  CheckListy
//
//  Created by Breno Lucas on 30/07/24.
//

import Foundation

struct UserDatabase {
    
    var id: String
    var name: String
    var urlProfileImage: URL
    
}

extension UserDatabase {
    
    func toNSDictionary() -> NSDictionary {
        return [
            "id": self.id,
            "name": self.name,
            "urlProfileImage": self.urlProfileImage.absoluteString
        ] as NSDictionary
    }
    
    static func fromNSDictionary(_ dictionary: NSDictionary) -> UserDatabase? {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let urlString = dictionary["urlProfileImage"] as? String,
              let urlProfileImage = URL(string: urlString) else {
            return nil
        }
        
        return UserDatabase(id: id, name: name, urlProfileImage: urlProfileImage)
    }
    
}

extension UserDatabase {
    
    func saveToDatabase() async throws {
        guard let dbRef = FirebaseDatabase.shared.databaseRef else {
            throw NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get database reference"])
        }

        let userDict = self.toNSDictionary()

        let _ : () = try await withCheckedThrowingContinuation { continuation in
            dbRef.child("users").child(self.id).setValue(userDict) { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    static func fetchFromDatabase(withId id: String) async throws -> UserDatabase {
        guard let dbRef = FirebaseDatabase.shared.databaseRef else {
            throw NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get database reference"])
        }

        return try await withCheckedThrowingContinuation { continuation in
            dbRef.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? NSDictionary else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch data"]))
                    return
                }

                if let user = UserDatabase.fromNSDictionary(value) {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse data"]))
                }
            }
        }
    }
    
}
