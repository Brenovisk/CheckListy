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
    
    @Published var userImage: UIImage? = nil
    @Published var userName: String? = nil
    
    @MainActor
    let userId = FirebaseAuthService.shared.getAuthUserId()
    
    var filterLists: Array<ListModel> {
        lists.compactMap{ $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var favorites: Array<ListModel>  {
        lists.compactMap{ $0 }.filter { $0.isFavorite }
    }

    var firebaseDatabase = FirebaseDatabase.shared

    @MainActor
    init() {
        setupCallbacksManager()
        firebaseDatabase.setupIfNeeded()
        self.lists = firebaseDatabase.data.compactMap { $0 }
    }
    
    @MainActor 
    func getUserName() {
        self.userName = FirebaseAuthService.shared.getAuthUserName()
    }
    
    @MainActor
    func getUserImage() async {
        self.userImage = await FirebaseAuthService.shared.getAuthUserImage()
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
    
    func getFirebaseList(by id: String) -> ListModel? {
        FirebaseDatabase.shared.data.compactMap({ $0 }).first(where: { $0.id.uuidString == id })
    }

    func getRecents() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func create(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.add(path: pathNewList, data: list.toNSDictionary())
    }
    
    func update(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.update(path: pathNewList, data: list.toNSDictionary())
    }
    
    @MainActor 
    func add(by code: String) {
        let pathNewList = "\(Paths.lists.description)/\(code)"
        guard let list = getFirebaseList(by: code) else { return }
        var listToEdit = list
        let userId = FirebaseAuthService.shared.getAuthUserId()
        listToEdit.users.append(userId)
        firebaseDatabase.update(path: pathNewList, data: listToEdit.toNSDictionary())
    }

    func delete(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.delete(path: pathNewList)
    }

    @MainActor
    func signOut() {
        Task {
            do {
                self.lists = []
                FirebaseDatabase.shared.removeListeners()
                FirebaseDatabase.shared.clearData()
                UserDefaultsService.clearAll()
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

    @MainActor
    private func setupCallbacksManager() {
        firebaseDatabase.dataChanged = { [weak self] in
            guard let self else { return }
            self.lists = (self.firebaseDatabase.data.compactMap{ $0 }.filter { $0.users.contains(self.userId)
            })
        }
    }

}

// MARK: - Typealias
extension ListsViewModel {

    typealias Paths = FirebaseDatabasePaths

}

