//
//  ListItemModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ListItemModel: Identifiable, Hashable {
    
    let id: UUID = UUID()
    var name: String
    var description: String
    var color: Color
    var isCheck: Bool
    
}
