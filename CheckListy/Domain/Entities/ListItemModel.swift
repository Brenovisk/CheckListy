//
//  ListItemModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation

struct ListItemModel: Identifiable, Hashable, ConvertibleDictionary {
    var id: UUID = .init()
    var name: String
    var description: String = .init()
    var section: String = .init()
    var isCheck: Bool
    
    func toNSDictionary() -> NSDictionary {
        [
            "id": id.uuidString,
            "name": name,
            "description": description,
            "section": section,
            "isCheck": isCheck
        ]
    }
    
    static func fromNSDictionary(_ dictionary: NSDictionary) -> ListItemModel? {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = dictionary["name"] as? String
        else {
            return nil
        }
        
        let description = dictionary["description"] as? String ?? ""
        let section = dictionary["section"] as? String ?? ""
        let isCheck = dictionary["isCheck"] as? Bool ?? false
        
        return ListItemModel(
            id: id,
            name: name,
            description: description,
            section: section,
            isCheck: isCheck
        )
    }
}
