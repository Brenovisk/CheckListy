//
//  ListsViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation
import SwiftUI
import Combine

class ListsViewModel: ObservableObject {

    @Published var lists: [ListModel?] = []
    @Published var listToEdit: ListModel? = nil
    @Published var selectedList: ListModel? = nil
    @Published var visualizationMode: ListMode = .list
    @Published var showSearchBar: Bool = false
    @Published var searchText: String = String()
    @Published var recentsSection: SectionModel<String> = SectionModel(name: "Recentes", items: [])
    @Published var favoritesSection: SectionModel<ListModel> = SectionModel(name: "Favoritos", items: [])
    
    var filterLists: Array<ListModel> {
        lists.compactMap{ $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var favorites: Array<ListModel>  {
        lists.compactMap{ $0 }.filter { $0.isFavorite }
    }

    private let firebaseDataBase = FirebaseDatabase.shared

    init() {
        setupCallbacksManager()
        self.lists = firebaseDataBase.data
    }
    
    func getLists() -> Array<ListModel?> {
        searchText.isEmpty ? lists : filterLists
    }

    func toggleIsFavorite(to list: ListModel) {
        withAnimation {
            var listToEdit = list
            listToEdit.isFavorite = !list.isFavorite
            update(list: listToEdit)        }
    }
    
    func toggleSearchBar() {
        withAnimation {
            showSearchBar.toggle()
        }
    }
    
    func toggleCollapseRecentSection() {
        withAnimation {
            recentsSection.collapsed = !recentsSection.collapsed
        }
    }
    
    func toggleCollapseFavoritesSection() {
        withAnimation {
            favoritesSection.collapsed = !favoritesSection.collapsed
        }
    }

    func addRecent(listId: String) {
        UserDefaultsService.addItem(key: .recents, listId)
    }

    func getList(by id: String) -> ListModel? {
        lists.compactMap({ $0 }).first(where: { $0.id.uuidString == id })
    }

    func getRecents() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func create(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.add(path: pathNewList, data: list.toNSDictionary())
    }
    
    func update(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.update(path: pathNewList, data: list.toNSDictionary())
    }

    func delete(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.delete(path: pathNewList)
    }

    func signOut() {
        Task {
            do {
                try await FirebaseAuthService.shared.signOut()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }

    func toggleVisualization() {
        withAnimation {
            visualizationMode = visualizationMode == .list ? .grid : .list
        }
    }
    
    func setVisualizationMode(according verticalSizeClass: UserInterfaceSizeClass?) {
        withAnimation {
            visualizationMode = verticalSizeClass == .regular ? .list : .grid
        }
    }

}

// MARK: - Helper methods
extension ListsViewModel {

    private func setupCallbacksManager() {
        firebaseDataBase.dataChanged = { [weak self] in
            self?.lists = self?.firebaseDataBase.data ?? []      
        }
    }

}

// MARK: - Typealias
extension ListsViewModel {

    typealias Paths = FirebaseDatabasePaths

}

