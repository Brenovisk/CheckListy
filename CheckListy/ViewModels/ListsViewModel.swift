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
    @Published var contentToShare: Array<Any> = []
    @Published var selectedList: ListModel? = nil
    @Published var visualizationMode: ListMode = .list
    @Published var showSearchBar: Bool = false
    @Published var searchText: String = String()
    @Published var recentsSection: SectionModel<String> = SectionModel(name: "Recentes", items: [])
    @Published var favoritesSection: SectionModel<ListModel> = SectionModel(name: "Favoritos", items: [])
    
    @Published var userImage: UIImage? = nil
    @Published var userName: String? = nil
    private var cancellables = Set<AnyCancellable>()
    
    var filterLists: Array<ListModel> {
        lists.compactMap{ $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var favorites: Array<ListModel>  {
        lists.compactMap{ $0 }.filter { $0.isFavorite }
    }
    
    var firebaseDatabase = FirebaseDatabase.shared
    
    @MainActor
    init() {
        firebaseDatabase.setupIfNeeded()
        subscribeToDatabaseChanges()
    }
    
    @MainActor 
    func subscribeToDatabaseChanges() {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        firebaseDatabase.dataChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.lists = data.compactMap{ $0 }.filter { $0.users.contains(user.uid) }
            }.store(in: &cancellables)
    }
    
    @MainActor
    func getUserName() {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        let userManager = UserManager(authUser: user)
        self.userName = userManager.getName()
    }
    
    @MainActor
    func getUserImage() async {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        let userManager = UserManager(authUser: user)
        self.userImage = try? await userManager.getImage()
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
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        guard let listId = code.removingSuffix(".co").fromBase64Code(),
              let list = getFirebaseList(by: listId) else {
            return
        }
        
        let pathNewList = "\(Paths.lists.description)/\(listId)"
        
        var listToEdit = list
        listToEdit.users.append(user.uid)
        
        firebaseDatabase.update(path: pathNewList, data: listToEdit.toNSDictionary())
    }
    
    func delete(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.delete(path: pathNewList)
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
    
    func setContentToShared(to list: ListModel) {
        let listCode = list.id.uuidString.toBase64Code().addingSuffix(".co")
        let shareMessage = """
           Quero compartilhar a lista **\(list.name)** com você.\n
           Copie o código abaixo e use na seção de adicionar lista:
           \n\(listCode)\n
           """
        self.contentToShare = [shareMessage]
    }
    
}

// MARK: - Typealias
extension ListsViewModel {
    
    typealias Paths = FirebaseDatabasePaths
    
}

