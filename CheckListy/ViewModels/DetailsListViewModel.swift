//
//  ListItemViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation
import SwiftUI

class DetailsListViewModel: ObservableObject {
    
    @Published var items: Array<ListItemModel>
    @Published var detailsList: ListModel?
    private let firebaseDataBase = FirebaseDatabase.shared
    
    init(_ list: ListModel) {
        self.items = list.items
        self.detailsList = list
    }
    
    func updateList(with newList: ListModel) {
        guard let detailsList else { return }
        let pathNewList = "\(FirebaseDatabasePaths.lists.description)/\(detailsList.id.uuidString)"
        firebaseDataBase.update(path: pathNewList, data: newList.toNSDictionary())
        self.detailsList = newList
    }
    
    func set(isCheck: Bool, of item: ListItemModel) {
        let index = items.firstIndex(of: item)
        guard let index else { return }
        items[index].isCheck = isCheck
    }
    
    func set(isCheck: Bool, of index: Int) {
        items[index].isCheck = isCheck
    }
    
    func changeItemIfNeeded(according transcript: String) {
        checkItem(according: transcript)
        unCheckItem(according: transcript)
    }
    
    func checkItem(according transcript: String) {
        execute(command: .ok, to: transcript) { index in
            set(isCheck: true, of: index)
        }
    }
    
    func unCheckItem(according transcript: String) {
        execute(command: .not, to: transcript) { index in
            set(isCheck: false, of: index)
        }
    }
    
    func execute(command: Commands, to transcript: String, completion: (Int) -> Void) {
        let word = command.rawValue.lowercased()
        let transcriptLowercased = transcript.lowercased()
        
        guard transcriptLowercased.contains(word) else { return }
        let transcriptFormatted = transcriptLowercased.remove(word).removeWhiteSpaces()
        
        let index = items.firstIndex(where: { $0.name.lowercased().removeWhiteSpaces() == transcriptFormatted })
        guard let index else { return }
        completion(index)
    }
    
}

enum Commands: String {
    
    case ok = "ok"
    case not = "não"
    
}
