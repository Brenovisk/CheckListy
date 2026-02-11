//
//  DetailsListViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import AudioToolbox
import Combine
import Foundation
import SwiftUI

class DetailsListViewModel: ObservableObject {

    private let repository: ListsRepositoryProtocol
    private let router: AppRouter
    private var cancellables = Set<AnyCancellable>()

    @Published var itemToEdit: ListItemModel?
    @Published var sectionSelected: String = .init()
    @Published var sections: [SectionModel<ListItemModel>] = []
    @Published var showSearchBar: Bool = false
    @Published var searchText: String = .init()

    @Published var list: ListModel {
        didSet {
            getSections()
        }
    }

    var filterItems: [ListItemModel] {
        list.items.compactMap { $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    @MainActor
    init(_ list: ListModel, router: AppRouter, repository: ListsRepositoryProtocol) {
        self.list = list
        self.router = router
        self.repository = repository
        setup(to: list)
        subscribeToDatabaseChanges()
    }

    func subscribeToDatabaseChanges() {
        repository.observeLists(userId: list.owner)
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.list = data.first(where: { $0.id == self.list.id }) ?? self.list
            }
            .store(in: &cancellables)
    }

    func getItems() -> [ListItemModel] {
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

        var sections: [SectionModel<ListItemModel>] = validSections.compactMap { sectionName, items in
            let sectionList = getSection(by: sectionName)
            return SectionModel(
                name: sectionName,
                items: items,
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
        sections.first(where: { name == $0.name })
    }

    func setCollapsed(of section: SectionModel<ListItemModel>, with value: Bool) {
        guard let index = sections.firstIndex(where: { $0.id == section.id }) else { return }
        sections[index].collapsed = value
    }

    func updateList(with newList: ListModel) {
        Task {
            do {
                try await repository.update(list: newList)
                await MainActor.run {
                    list = newList
                }
            } catch {
                print("Error updating list: \(error)")
            }
        }
    }

    func add(_ item: ListItemModel) {
        var updatedList = list
        updatedList.items.append(item)
        updateList(with: updatedList)
    }

    func update(_ item: ListItemModel) {
        guard let indexItem = getIndex(of: item) else { return }
        var updatedList = list
        updatedList.items[indexItem] = item
        
        Task {
            do {
                try await repository.update(list: updatedList)
                executeFeedbacks()
            } catch {
                print("Error updating item: \(error)")
            }
        }
    }

    func remove(_ item: ListItemModel) {
        guard let indexItem = getIndex(of: item) else { return }
        var updatedList = list
        updatedList.items.remove(at: indexItem)
        updateList(with: updatedList)
    }

    func getIndex(of item: ListItemModel) -> Int? {
        list.items.firstIndex(where: { $0.id == item.id })
    }

    func set(isCheck: Bool, of item: ListItemModel) {
        guard let index = getIndex(of: item) else { return }
        var updatedItem = list.items[index]
        updatedItem.isCheck = isCheck
        update(updatedItem)
    }

    func set(isCheck: Bool, of index: Int) {
        guard list.items.indices.contains(index) else { return }
        var updatedItem = list.items[index]
        updatedItem.isCheck = isCheck
        update(updatedItem)
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
        return "\(checkedItems)/\(total)"
    }

    func getCheckedItemBy(section: SectionModel<ListItemModel>) -> String {
        let total = section.items.count
        let checkedItems = section.items.filter { $0.isCheck }.count
        return "\(checkedItems)/\(total)"
    }

    private func executeFeedbacks() {
        FeedbackService().provideHapticFeedback() // Using instance instead of shared
        FeedbackService().playCheckSoundFeedback()
    }

}

enum Commands: String {
    case ok // swiftlint:disable:this identifier_name
    case not = "não"
}
