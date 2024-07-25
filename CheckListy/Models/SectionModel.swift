//
//  SectionModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 18/07/24.
//

import Foundation

struct SectionModel<Item: Hashable>: Identifiable {
    
    var id: UUID = UUID()
    var name: String
    var items: [Item]
    var collapsed: Bool = false
    
}
