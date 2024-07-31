//
//  ListModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation

struct ListModel: Identifiable, Hashable {
    
    var id: UUID = UUID()
    var name: String = String()
    var description: String = String()
    var color: String = String()
    var icon: String = String()
    var items: Array<ListItemModel> = []
    var isFavorite: Bool = false
    var createdAt: Date = Date()
    var editedAt: Date = Date()
    var users: [String] = []
    
}

extension ListModel {
    
    func toNSDictionary() -> NSDictionary {
        [
            "id": id.uuidString,
            "name": name,
            "description": description,
            "color": color,
            "icon": icon,
            "items": items.map { $0.toNSDictionary() },
            "isFavorite": isFavorite,
            "createdAt": formattedDateUTC(createdAt),
            "editedAt": formattedDateUTC(editedAt),
            "users": users.map { $0 }
        ]
    }
    
    static func fromNSDictionary(_ dictionary: NSDictionary) -> ListModel? {
        let items = (dictionary["items"] as? Array<NSDictionary>)?.compactMap { ListItemModel.fromNSDictionary($0) } ?? []
        
        let isFavorite = dictionary["isFavorite"] as? Bool ?? false
        let createdAt = Date(timeIntervalSince1970: dictionary["createdAt"] as? TimeInterval ?? 0)
        let editedAt = Date(timeIntervalSince1970: dictionary["editedAt"] as? TimeInterval ?? 0)
        let users = (dictionary["users"] as? [String])?.compactMap { $0 } ?? []
        
        guard
            let id = UUID(uuidString: dictionary["id"] as? String ?? ""),
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let color = dictionary["color"] as? String,
            let icon = dictionary["icon"] as? String
        else {
            return nil
        }
        
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
            users: users
        )
    }
    
    var checkItems: String {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count
        return "\(checkedItems)/\(total)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ListModel, rhs: ListModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func formattedDateUTC(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter.string(from: date)
    }
}


