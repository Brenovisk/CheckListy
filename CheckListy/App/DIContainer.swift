//
//  DIContainer.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation

class DIContainer: ObservableObject {

    // Services / Data Sources
    let firebaseDatabase: FirebaseDatabase
    let firebaseAuthService: FirebaseAuthService
    let remoteImageDataSource: RemoteImageDataSource
    let localImageDataSource: LocalImageDataSource
    let feedbackService: FeedbackService

    // Repositories
    let listsRepository: ListsRepositoryProtocol
    let userRepository: UserRepositoryProtocol

    // Use Cases
    let fetchListsUseCase: FetchListsUseCase
    let toggleFavoriteUseCase: ToggleFavoriteUseCase
    let updateListUseCase: UpdateListUseCase
    let registerUserUseCase: RegisterUserUseCase

    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.firebaseAuthService = FirebaseAuthService()
        self.remoteImageDataSource = RemoteImageDataSource()
        self.localImageDataSource = LocalImageDataSource()
        self.feedbackService = FeedbackService()

        self.listsRepository = ListsRepository(firebaseDatabase: firebaseDatabase)
        self.userRepository = UserRepository(
            firebaseDatabase: firebaseDatabase,
            localImageDataSource: localImageDataSource,
            remoteImageDataSource: remoteImageDataSource
        )

        self.fetchListsUseCase = FetchListsUseCase(repository: listsRepository)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: listsRepository)
        self.updateListUseCase = UpdateListUseCase(repository: listsRepository)
        self.registerUserUseCase = RegisterUserUseCase(
            authService: firebaseAuthService,
            userRepository: userRepository
        )
    }
}
