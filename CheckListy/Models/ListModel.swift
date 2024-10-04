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

}

// MARK: Computed variables
extension ListModel {

    var checkItems: String {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count
        return "\(checkedItems)/\(total)"
    }

    var isComplete: Bool {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count
        return total == checkedItems
    }

    var createdDate: String {
        formattedDateToCard(createdAt)
    }

}

// MARK: Helper methods
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
            "owner": owner,
            "usersShared": usersShared.toNSDictionary()
        ]
    }

    static func fromNSDictionary(_ dictionary: NSDictionary) -> ListModel? {
        let items = (dictionary["items"] as? [NSDictionary])?.compactMap { ListItemModel.fromNSDictionary($0) } ?? []
        let isFavorite = dictionary["isFavorite"] as? Bool ?? false
        let usersShared = (dictionary["usersShared"] as? [String])?.compactMap { $0 } ?? []

        guard
            let id = UUID(uuidString: dictionary["id"] as? String ?? ""),
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let color = dictionary["color"] as? String,
            let icon = dictionary["icon"] as? String,
            let owner = dictionary["owner"] as? String,
            let createdAt = convertToDate(string: dictionary["createdAt"] as? String ?? String()),
            let editedAt = convertToDate(string: dictionary["editedAt"] as? String ?? String())
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
            owner: owner,
            usersShared: usersShared
        )
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

    func formattedDateToCard(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    private static func convertToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'h:mm:ss aZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = dateFormatter.date(from: string) else {
            return nil
        }

        return date
    }

}
