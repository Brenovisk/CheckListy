//
//  DetailsListViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation
import SwiftUI
import AudioToolbox

class DetailsListViewModel: ObservableObject {
    
    private let firebaseDataBase = FirebaseDatabase.shared
    
    @Published var itemToEdit: ListItemModel?
    @Published var sectionSelected: String = String()
    @Published var sections: Array<SectionModel<ListItemModel>> = []
    @Published var showSearchBar: Bool = false
    @Published var searchText: String = String()
    
    @Published var list: ListModel {
        didSet {
            getSections()
        }
    }
    
    var filterItems: Array<ListItemModel> {
        list.items.compactMap{ $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    init(_ list: ListModel) {
        self.list = list
        setup(to: list)
    }
    
    func getItems() -> Array<ListItemModel> {
        searchText.isEmpty ? list.items : filterItems
    }
    
    func toggleSearchBar() {
        withAnimation {
            showSearchBar.toggle()
        }
    }
    
    func setup(to list: ListModel) {
        setRecent(list.id.uuidString)
        getSections()
    }
    
    func getRecents() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func setRecent(_ id: String) {
        var ids = getRecents()
        ids.insert(id, at: 0)
        UserDefaultsService.save(.recents, ids)
    }
    
    func getSections() {
        let validSections = Dictionary(grouping: list.items.filter { !$0.section.isEmpty }, by: { $0.section })
        let emptySections = list.items.filter { $0.section.isEmpty }
        
        var sections: [SectionModel<ListItemModel>] = validSections.compactMap { (sectionName, items) in
            let sectionList = getSection(by: sectionName)
            return SectionModel(
                name: sectionName,
                items:  items,
                collapsed: sectionList?.collapsed ?? false
            )
        }
        
        if !emptySections.isEmpty {
            sections.insert(SectionModel(name: String(), items: emptySections), at: 0)
        }
        
        self.sections = sections.sorted(by: { $0.name < $1.name })
    }
    
    func move(_ item: ListItemModel, to section: SectionModel<ListItemModel>) {
        var itemToEdit = item
        itemToEdit.section = section.name
        update(itemToEdit)
    }
    
    func getSection(by name: String) -> SectionModel<ListItemModel>? {
        self.sections.first(where: { name == $0.name })
    }
    
    func setCollapsed(of section: SectionModel<ListItemModel>, with value: Bool) {
        guard let index = sections.firstIndex(where: { $0.id == section.id }) else { return }
        sections[index].collapsed = value
    }
    
    func updateList(with newList: ListModel) {
        let pathNewList = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.update(path: pathNewList, data: newList.toNSDictionary())
        self.list = newList
    }
    
    func add(_ item: ListItemModel) {
        let pathNewList = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        list.items.append(item)
        firebaseDataBase.update(path: pathNewList, data: list.toNSDictionary())
    }
    
    func update(_ item: ListItemModel) {
        let pathNewList = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        guard let indexItem = getIndex(of: item) else { return }
        list.items[indexItem] = item
        firebaseDataBase.update(path: pathNewList, data: list.toNSDictionary())
        executeFeedbacks()
    }
    
    func remove(_ item: ListItemModel) {
        let pathNewList = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        guard let indexItem = getIndex(of: item) else { return }
        list.items.remove(at: indexItem)
        firebaseDataBase.update(path: pathNewList, data: list.toNSDictionary())
    }
    
    func getIndex(of item: ListItemModel) -> Int? {
        list.items.firstIndex(where: { $0.id == item.id })
    }
    
    func set(isCheck: Bool, of item: ListItemModel) {
        guard let index = getIndex(of: item) else { return }
        list.items[index].isCheck = isCheck
        update(list.items[index])
    }
    
    func set(isCheck: Bool, of index: Int) {
        list.items[index].isCheck = isCheck
        update(list.items[index])
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
        
        let index = list.items.firstIndex(where: { $0.name.lowercased().removeWhiteSpaces() == transcriptFormatted })
        guard let index else { return }
        completion(index)
    }
    
    func getCheckedItemByList() -> String {
        let total = list.items.count
        let checkedItems = list.items.filter { $0.isCheck }.count
        return  "\(checkedItems)/\(total)"
    }
    
    func getCheckedItemBy(section: SectionModel<ListItemModel>) -> String {
        let total = section.items.count
        let checkedItems = section.items.filter { $0.isCheck }.count
        return  "\(checkedItems)/\(total)"
    }
    
    private func executeFeedbacks() {
        FeedbackService.shared.provideHapticFeedback()
        FeedbackService.shared.playCheckSoundFeedback()
    }
    
}

enum Commands: String {
    
    case ok = "ok"
    case not = "não"
    
}
