//
//  ListModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation

struct ListModel: Identifiable, Hashable, ConvertibleDictionary {

    var id: UUID = .init()
    var name: String = .init()
    var description: String = .init()
    var color: String = .init()
    var icon: String = .init()
    var items: [ListItemModel] = []
    var isFavorite: Bool = false
    var createdAt: Date = .init()
    var editedAt: Date = .init()
    var owner: String = .init()
    var usersShared: [String] = []

    // Domain Logic
    var isComplete: Bool {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count
        return total > 0 && total == checkedItems
    }
    
    var progressCompleted: Double {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count

        guard total != .zero else {
            return .zero
        }

        return Double(checkedItems) / Double(total)
    }
    
    var isShared: Bool {
        !usersShared.isEmpty
    }

    var checkItems: String {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count
        return "\(checkedItems)/\(total)"
    }

    var createdDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: createdAt)
    }
    
    func toNSDictionary() -> NSDictionary {
        let itemsDict = items.map { $0.toNSDictionary() }
        
        return [
            "id": id.uuidString,
            "name": name,
            "description": description,
            "color": color,
            "icon": icon,
            "items": itemsDict,
            "isFavorite": isFavorite,
            "createdAt": createdAt.timeIntervalSince1970,
            "editedAt": editedAt.timeIntervalSince1970,
            "owner": owner,
            "usersShared": usersShared
        ]
    }
    
    static func fromNSDictionary(_ dictionary: NSDictionary) -> ListModel? {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = dictionary["name"] as? String,
              let color = dictionary["color"] as? String,
              let icon = dictionary["icon"] as? String
        else {
            return nil
        }
        
        let description = dictionary["description"] as? String ?? ""
        let isFavorite = dictionary["isFavorite"] as? Bool ?? false
        let owner = dictionary["owner"] as? String ?? ""
        let usersShared = dictionary["usersShared"] as? [String] ?? []
        
        let createdAtTimestamp = dictionary["createdAt"] as? TimeInterval ?? 0
        let createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        
        let editedAtTimestamp = dictionary["editedAt"] as? TimeInterval ?? 0
        let editedAt = Date(timeIntervalSince1970: editedAtTimestamp)
        
        let itemsArray = dictionary["items"] as? [NSDictionary] ?? []
        let items = itemsArray.compactMap { ListItemModel.fromNSDictionary($0) }
        
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
}
