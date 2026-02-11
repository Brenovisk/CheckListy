//
//  ListsViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Combine
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
    @Published var isLoading: Bool = false

    var authUser: User?

    private var cancellables = Set<AnyCancellable>()
    
    // Use Cases
    private let fetchListsUseCase: FetchListsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let updateListUseCase: UpdateListUseCase
    private let userRepository: UserRepositoryProtocol // Keep for user specific profile logic

    var filterLists: [ListModel] {
        lists.compactMap { $0 }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var favorites: [ListModel] {
        lists.compactMap { $0 }.filter { $0.isFavorite }
    }

    var recents: [ListModel] {
        recentsSection.items.compactMap { listId in
            getList(by: listId)
        }
    }

    var allLists: [ListModel] {
        (searchText.isEmpty ? lists : filterLists).compactMap { $0 }
    }

    var incompleteLists: [ListModel] {
        lists.compactMap { $0 }.filter { !$0.isComplete }
    }

    var completeLists: [ListModel] {
        lists.compactMap { $0 }.filter { $0.isComplete }
    }

    var showRecentSection: Bool {
        !recentsSection.items.isEmpty && !showSearchBar && !lists.isEmpty
    }

    var showFavoriteSection: Bool {
        !favorites.isEmpty && !showSearchBar && !lists.isEmpty
    }

    @MainActor
    init(
        fetchListsUseCase: FetchListsUseCase = FetchListsUseCase(),
        toggleFavoriteUseCase: ToggleFavoriteUseCase = ToggleFavoriteUseCase(),
        updateListUseCase: UpdateListUseCase = UpdateListUseCase(),
        userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.fetchListsUseCase = fetchListsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.updateListUseCase = updateListUseCase
        self.userRepository = userRepository
        setupDataBase()
    }

    @MainActor
    func setupDataBase() {
        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
        authUser = user
        subscribeToDatabaseChanges(userId: user.uid)
    }

    @MainActor
    func subscribeToDatabaseChanges(userId: String) {
        isLoading = true
        fetchListsUseCase.execute(userId: userId)
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.lists = data
                self.isLoading = false
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
        if let data = try? await userRepository.getProfileImageData(userId: user.uid),
           let image = UIImage(data: data) {
            userImage = image
        }
    }

    func toggleIsFavorite(to list: ListModel) {
        Task {
            do {
                try await toggleFavoriteUseCase.execute(list: list)
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
    }

    func toggleSearchBar() {
        withAnimation {
            showSearchBar.toggle()
            guard !showSearchBar else { return }
            searchText = String()
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

    func getList(by id: String) -> ListModel? {
        lists.compactMap { $0 }.first(where: { $0.id.uuidString == id })
    }

    func getFirebaseList(by id: String) -> ListModel? {
        getList(by: id)
    }

    func getRecentsListId() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func create(list: ListModel) {
        Task {
            do {
                // For simplicity, reuse updateListUseCase for saving if it handles it,
                // or create a SaveListUseCase.
                try await updateListUseCase.execute(list: list)
            } catch {
                print("Error creating list: \(error)")
            }
        }
    }

    func update(list: ListModel) {
        Task {
            do {
                try await updateListUseCase.execute(list: list)
            } catch {
                print("Error updating list: \(error)")
            }
        }
    }

    @MainActor
    func addList(by code: String) {
        // ... (Sharing logic placeholder)
    }

    @MainActor
    func delete(list: ListModel) {
        // Logic should be moved to a DeleteListUseCase
        deleteFromRecentsIfNeeded(list: list)
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

    private func deleteFromRecentsIfNeeded(list: ListModel) {
        recentsSection.items.removeAll { $0 == list.id.uuidString }
        var persistedRecentLists = getRecentsListId()
        persistedRecentLists.removeAll { $0 == list.id.uuidString }
        UserDefaultsService.save(.recents, persistedRecentLists)
    }
}

// MARK: - Helper methods
extension ListsViewModel {

    private func getIndex(of list: ListModel) -> Int? {
        lists.firstIndex(where: { $0?.id == list.id })
    }

    private func deleteFromRecentsIfNeeded(list: ListModel) {
        recentsSection.items.removeAll { $0 == list.id.uuidString }
        var persistedRecentLists = getRecentsListId()
        persistedRecentLists.removeAll { $0 == list.id.uuidString }
        UserDefaultsService.save(.recents, persistedRecentLists)
    }
}

// MARK: - Typealias
extension ListsViewModel {

    typealias Paths = FirebaseDatabasePaths

}
