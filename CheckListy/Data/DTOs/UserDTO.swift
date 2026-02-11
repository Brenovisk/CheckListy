//
//  UserDTO.swift
//  CheckListy
//

import Foundation

struct UserDTO {
    
    static func toDomain(_ dictionary: NSDictionary) -> UserProfile? {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String
        else {
            return nil
        }
        
        let lists = dictionary["lists"] as? [String] ?? []
        
        return UserProfile(
            id: id,
            name: name,
            email: "",
            lists: lists
        )
    }

    static func fromDomain(_ user: UserProfile) -> NSDictionary {
        [
            "id": user.id,
            "name": user.name,
            "lists": user.lists,
            "urlProfileImage": ""
        ]
    }
}
