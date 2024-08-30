//
//  ListsViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Combine
import Firebase
import Foundation
import SwiftUI

class ListsViewModel: ObservableObject {

    @Published var lists: [ListModel?] = []
    @Published var listToEdit: ListModel?
    @Published var contentToShare: [Any] = []
    @Published var selectedList: ListModel?
    @Published var visualizationMode: ListMode = .list
    @Published var showSearchBar: Bool = false
    @Published var searchText: String = .init()
    @Published var recentsSection: SectionModel<String> = SectionModel(name: "Recentes", items: [])
    @Published var favoritesSection: SectionModel<ListModel> = SectionModel(name: "Favoritos", items: [])
    @Published var userImage: UIImage?
    @Published var userName: String?

    var authUser: User?

    private var cancellables = Set<AnyCancellable>()

    var filterLists: [ListModel] {
        lists.compactMap { $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var favorites: [ListModel] {
        lists.compactMap { $0 }.filter { $0.isFavorite }
    }

    var firebaseDatabase = FirebaseDatabase.shared

    @MainActor
    init() {
        setupDataBase()
        subscribeToDatabaseChanges()
    }

    @MainActor
    func setupDataBase() {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        authUser = user
        firebaseDatabase.observeUserLists(userId: user.uid)
    }

    @MainActor
    func subscribeToDatabaseChanges() {
        firebaseDatabase.dataChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.lists = data
            }.store(in: &cancellables)
    }

    @MainActor
    func getUserName() {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        let userManager = UserManager(authUser: user)
        userName = userManager.getName()
    }

    @MainActor
    func getUserImage() async {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        let userManager = UserManager(authUser: user)
        userImage = try? await userManager.getImage()
    }

    func getLists() -> [ListModel?] {
        searchText.isEmpty ? lists : filterLists
    }

    func toggleIsFavorite(to list: ListModel) {
        withAnimation {
            var listToEdit = list
            listToEdit.isFavorite = !list.isFavorite
            update(list: listToEdit)
        }
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
        lists.compactMap { $0 }.first(where: { $0.id.uuidString == id })
    }

    func getFirebaseList(by id: String) -> ListModel? {
        FirebaseDatabase.shared.data.compactMap { $0 }.first(where: { $0.id.uuidString == id })
    }

    func getRecents() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func create(list: ListModel) {
        guard authUser != nil else { return }

        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.add(path: pathNewList, data: list.toNSDictionary())

        createUser(list: list)
        firebaseDatabase.addObserverList(with: list.id.uuidString)
    }

    func createUser(list: ListModel) {
        guard let authUser else { return }

        let pathUserLists = "\(Paths.users.description)/\(authUser.uid)/lists"
        var listsId = lists.compactMap { $0?.id.uuidString }
        listsId.append(list.id.uuidString)
        firebaseDatabase.update(path: pathUserLists, data: listsId.toNSDictionary())
    }

    func update(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.update(path: pathNewList, data: list.toNSDictionary())
    }

    @MainActor
    func addList(by code: String) {
        guard let listId = code.removingSuffix(".co").fromBase64Code(),
              let authUser else { return }

        let pathUserLists = "\(Paths.users.description)/\(authUser.uid)/lists"
        var listsId = lists.compactMap { $0?.id.uuidString }
        listsId.append(listId)

        firebaseDatabase.update(path: pathUserLists, data: listsId.toNSDictionary())
        firebaseDatabase.addObserverList(with: listId)
    }

    func delete(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.delete(path: pathNewList)
        deleteUser(list)
    }

    func deleteUser(_ list: ListModel) {
        guard let authUser else { return }
        let pathUserLists = "\(Paths.users.description)/\(authUser.uid)/lists"

        guard let indexItem = getIndex(of: list) else { return }
        lists.remove(at: indexItem)

        let listsId = lists.compactMap { $0?.id.uuidString }
        firebaseDatabase.update(path: pathUserLists, data: listsId.toNSDictionary())
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
        contentToShare = [shareMessage]
    }

}

// MARK: - Helper methods
extension ListsViewModel {

    private func getIndex(of list: ListModel) -> Int? {
        lists.firstIndex(where: { $0?.id == list.id })
    }

}

// MARK: - Typealias
extension ListsViewModel {

    typealias Paths = FirebaseDatabasePaths

}
