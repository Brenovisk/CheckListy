//
//  ListModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation

struct ListModel: Identifiable, Hashable {

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
}
