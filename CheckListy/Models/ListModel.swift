//
//  ListModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation
import UIKit

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

    var isShared: Bool {
        usersShared.count > .zero
    }

    var createdDate: String {
        formattedDateToCard(createdAt)
    }

    var progressCompleted: Double {
        let total = items.count
        let checkedItems = items.filter { $0.isCheck }.count

        guard total != .zero else {
            return .zero
        }

        return Double(checkedItems) / Double(total)
    }

}

// MARK: Model methods
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
        let timeService = TimeService()

        guard
            let id = UUID(uuidString: dictionary["id"] as? String ?? ""),
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let color = dictionary["color"] as? String,
            let icon = dictionary["icon"] as? String,
            let owner = dictionary["owner"] as? String,
            let createdAt = timeService.convertToDate(string: dictionary["createdAt"] as? String ?? String()),
            let editedAt = timeService.convertToDate(string: dictionary["editedAt"] as? String ?? String())
        else {
            return nil
        }

        let items = (dictionary["items"] as? [NSDictionary])?.compactMap { ListItemModel.fromNSDictionary($0) } ?? []
        let isFavorite = dictionary["isFavorite"] as? Bool ?? false
        let usersShared = (dictionary["usersShared"] as? [String])?.compactMap { $0 } ?? []

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

    func getUsersSharedImagesProfile() async -> [UIImage] {
        var images = [UIImage]()
        var usersSharedWithOwner = usersShared
        usersSharedWithOwner.insert(owner, at: 0)

        for id in usersSharedWithOwner {
            guard let image = try? await UserService.getUserDatabaseImage(for: id) else {
                continue
            }

            images.append(image)
        }

        return images
    }

}

// MARK: - Helper methods
extension ListModel {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ListModel, rhs: ListModel) -> Bool {
        lhs.id == rhs.id
    }

    private func formattedDateUTC(_ date: Date) -> String {
        TimeService().getDateString(from: date)
    }

    private func formattedDateToCard(_ date: Date) -> String {
        TimeService().getDateString(from: date, format: "dd/MM/yyyy")
    }

}
