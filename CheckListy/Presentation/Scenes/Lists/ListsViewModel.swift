//
//  ListsViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Combine
import Foundation
import SwiftUI
import FirebaseAuth

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
    
    let router: AppRouter
    let authService: FirebaseAuthService
    private let fetchListsUseCase: FetchListsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let updateListUseCase: UpdateListUseCase
    private let deleteListUseCase: DeleteListUseCase
    private let userRepository: UserRepositoryProtocol

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
        router: AppRouter,
        authService: FirebaseAuthService,
        fetchListsUseCase: FetchListsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        updateListUseCase: UpdateListUseCase,
        deleteListUseCase: DeleteListUseCase,
        userRepository: UserRepositoryProtocol
    ) {
        self.router = router
        self.authService = authService
        self.fetchListsUseCase = fetchListsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.updateListUseCase = updateListUseCase
        self.deleteListUseCase = deleteListUseCase
        self.userRepository = userRepository
        setupDataBase()
    }

    @MainActor
    func setupDataBase() {
        guard let user = try? authService.getAuthUser() else { return }
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
        guard let user = try? authService.getAuthUser() else { return }
        
        let storedName = UserDefaultsService.loadItem(.userName)
        if !storedName.isEmpty {
            userName = storedName
        } else {
            let name = user.displayName ?? ""
            UserDefaultsService.add(.userName, name)
            userName = name
        }
    }

    @MainActor
    func getUserImage() async {
        guard let user = try? authService.getAuthUser() else { return }
        if let data = try? await userRepository.getProfileImageData(userId: user.uid),
           let image = UIImage(data: data) {
            userImage = image
        }
    }
    
    @MainActor
    func navigateToProfile() {
        router.navigate(to: .profile)
    }
    
    @MainActor
    func navigateToDetails(list: ListModel) {
        router.navigate(to: .details(list))
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

    func getRecentsListId() -> [String] {
        UserDefaultsService.load(.recents).removingDuplicates()
    }

    func create(list: ListModel) {
        Task {
            do {
                try await updateListUseCase.execute(list: list)
                try await appendListToUser(listId: list.id.uuidString)
            } catch {
                print("Error creating list: \(error)")
            }
        }
    }

    @MainActor
    func update(list: ListModel) {
        Task {
            do {
                try await updateListUseCase.execute(list: list)
            } catch {
                debugPrint("Error updating list: \(error)")
            }
        }
    }

    @MainActor
    func addList(by code: String) {
    }

    @MainActor
    func delete(list: ListModel) {
        Task {
            do {
                try await deleteListUseCase.execute(list: list)
                try await removeListToUser(listId: list.id.uuidString)
                deleteFromRecentsIfNeeded(list: list)
            } catch {
                debugPrint("Error updating list: \(error)")
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

    private func deleteFromRecentsIfNeeded(list: ListModel) {
        recentsSection.items.removeAll { $0 == list.id.uuidString }
        var persistedRecentLists = getRecentsListId()
        persistedRecentLists.removeAll { $0 == list.id.uuidString }
        UserDefaultsService.save(.recents, persistedRecentLists)
    }
    
    @MainActor
    private func appendListToUser(listId: String) async throws {
        guard let user = try? authService.getAuthUser() else { return }
        var userProfile = try await userRepository.fetchUser(userId: user.uid)
        
        if !userProfile.lists.contains(listId) {
            userProfile.lists.append(listId)
            try await userRepository.saveUser(userProfile)
        }
    }
    
    @MainActor
    private func removeListToUser(listId: String) async throws {
        guard let user = try? authService.getAuthUser() else { return }
        var userProfile = try await userRepository.fetchUser(userId: user.uid)
        
        if userProfile.lists.contains(listId),
           let index = userProfile.lists.firstIndex(of: listId) {
            userProfile.lists.remove(at: index)
            try await userRepository.saveUser(userProfile)
        }
    }
}
