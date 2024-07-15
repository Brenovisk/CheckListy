//
//  ListItemModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ListItemModel: Identifiable, Hashable {
    
    var id: UUID = UUID()
    var name: String
    var description: String
    var section: String
    var isCheck: Bool
    
}

extension ListItemModel {
    
    func toNSDictionary() -> NSDictionary {
        [
            "id" : id.uuidString,
            "name": name,
            "description": description,
            "section": section,
            "isCheck": isCheck
        ]
    }
    
    static func fromNSDictionary(_ dictionary: NSDictionary) -> ListItemModel? {
        
        
        guard
            let id = UUID(uuidString: dictionary["id"] as? String ?? "") ,
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
    
}
