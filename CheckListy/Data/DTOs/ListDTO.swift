//
//  ListDTO.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation

struct ListDTO {
    
    static func toDomain(_ dictionary: NSDictionary) -> ListModel? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard
            let idString = dictionary["id"] as? String,
            let id = UUID(uuidString: idString),
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let color = dictionary["color"] as? String,
            let icon = dictionary["icon"] as? String,
            let owner = dictionary["owner"] as? String,
            let createdAtString = dictionary["createdAt"] as? String,
            let editedAtString = dictionary["editedAt"] as? String,
            let createdAt = dateFormatter.date(from: createdAtString),
            let editedAt = dateFormatter.date(from: editedAtString)
        else {
            return nil
        }

        let itemsDict = dictionary["items"] as? [NSDictionary] ?? []
        let items = itemsDict.compactMap { ListItemDTO.toDomain($0) }
        let isFavorite = dictionary["isFavorite"] as? Bool ?? false
        let usersShared = dictionary["usersShared"] as? [String] ?? []

        return ListModel(
            id: id,
            name: name,
            description: description,
            color: color,
            icon: icon,
            items: items,
            isFavorite: isFavorite,
            createdAt: createdAt,
            editedAt: editedAt,
            owner: owner,
            usersShared: usersShared
        )
    }

    static func fromDomain(_ list: ListModel) -> NSDictionary {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        return [
            "id": list.id.uuidString,
            "name": list.name,
            "description": list.description,
            "color": list.color,
            "icon": list.icon,
            "items": list.items.map { ListItemDTO.fromDomain($0) },
            "isFavorite": list.isFavorite,
            "createdAt": dateFormatter.string(from: list.createdAt),
            "editedAt": dateFormatter.string(from: list.editedAt),
            "owner": list.owner,
            "usersShared": list.usersShared
        ]
    }
}

struct ListItemDTO {
    static func toDomain(_ dictionary: NSDictionary) -> ListItemModel? {
        guard
            let idString = dictionary["id"] as? String,
            let id = UUID(uuidString: idString),
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let section = dictionary["section"] as? String,
            let isCheck = dictionary["isCheck"] as? Bool
        else {
            return nil
        }

        return ListItemModel(
            id: id,
            name: name,
            description: description,
            section: section,
            isCheck: isCheck
        )
    }

    static func fromDomain(_ item: ListItemModel) -> NSDictionary {
        [
            "id": item.id.uuidString,
            "name": item.name,
            "description": item.description,
            "section": item.section,
            "isCheck": item.isCheck
        ]
    }
}
