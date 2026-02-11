//
//  ListItemModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation

struct ListItemModel: Identifiable, Hashable {
    var id: UUID = .init()
    var name: String
    var description: String = .init()
    var section: String = .init()
    var isCheck: Bool
}
