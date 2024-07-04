//
//  ListItemViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation
import SwiftUI

class ListItemViewModel: ObservableObject {
    
    @Published var items: Array<ListItemModel> = [
        ListItemModel(name: "Macarrão", description: "Description", color: Color.red, isCheck: false),
        ListItemModel(name: "Feijão", description: "Description", color: Color.red, isCheck: false),
        ListItemModel(name: "Ovos", description: "Description", color: Color.red, isCheck: false)
    ]
    
    func set(isCheck: Bool, of item: ListItemModel) {
        let index = items.firstIndex(of: item)
        items[index!].isCheck = isCheck
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
