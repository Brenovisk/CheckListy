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
        Task {
            do {
                guard let listId = code.removingSuffix(".co").fromBase64Code(),
                      let authUser else { return }

                addList(with: listId, in: authUser)
                try await addUserShared(with: authUser.uid, from: listId)
                firebaseDatabase.addObserverList(with: listId)
            } catch {
                print(error)
            }
        }
    }

    func delete(list: ListModel) {
        Task {
            do {
                guard let authUser else { return }
                let isOwner = list.owner == authUser.uid

                if !isOwner {
                    try await deleteUserShared(with: authUser.uid, from: list)
                }

                try await deleteList(with: list.id.uuidString, in: authUser.uid)
                try await deleteListFromDatabaseIfNeeded(list)
                await setupDataBase()
            } catch {
                print(error)
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

    @MainActor
    private func getUsersSharedList(with id: String) async throws -> [String] {
        let list: ListModel = try await firebaseDatabase.getData(from: .lists, with: id)
        return list.usersShared
    }

    @MainActor
    private func getListsUser(with id: String) async throws -> [String] {
        let user: UserDatabase = try await firebaseDatabase.getData(from: .users, with: id)
        return user.lists
    }

    @MainActor
    private func addList(with id: String, in user: User) {
        let pathUserLists = "\(Paths.users.description)/\(user.uid)/lists"

        var listsId = lists.compactMap { $0?.id.uuidString }
        listsId.append(id)
        firebaseDatabase.update(path: pathUserLists, data: listsId.toNSDictionary())
    }

    @MainActor
    private func deleteListFromAllUsersShared(_ list: ListModel) async throws {
        let usersShared = try await getUsersSharedList(with: list.id.uuidString)

        for userId in usersShared {
            try await deleteList(with: list.id.uuidString, in: userId)
        }
    }

    @MainActor
    private func deleteListFromDatabaseIfNeeded(_ list: ListModel) async throws {
        let usersShared = try await getUsersSharedList(with: list.id.uuidString)
        guard usersShared.isEmpty else { return }
        let pathList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.delete(path: pathList)
    }

    @MainActor
    private func deleteList(with id: String, in userId: String) async throws {
        let pathUserLists = "\(Paths.users.description)/\(userId)/lists"
        var userLists = try await getListsUser(with: userId)
        userLists.removeAll { $0 == id }

        firebaseDatabase.update(path: pathUserLists, data: userLists.toNSDictionary())
    }

    @MainActor
    private func addUserShared(with id: String, from listId: String) async throws {
        var usersShared = try await getUsersSharedList(with: listId)
        usersShared.append(id)
        updateUsersShared(of: listId, with: usersShared)
    }

    @MainActor
    private func deleteUserShared(with id: String, from list: ListModel) async throws {
        var usersShared = try await getUsersSharedList(with: list.id.uuidString)
        usersShared.removeAll { $0 == id }
        updateUsersShared(of: list.id.uuidString, with: usersShared)
    }

    @MainActor
    private func updateUsersShared(of listId: String, with usersId: [String]) {
        let pathUsersSharedOfList = "\(FirebaseDatabasePaths.lists.description)/\(listId)/usersShared"
        firebaseDatabase.update(path: pathUsersSharedOfList, data: usersId.toNSDictionary())
    }

}

// MARK: - Typealias
extension ListsViewModel {

    typealias Paths = FirebaseDatabasePaths

}
