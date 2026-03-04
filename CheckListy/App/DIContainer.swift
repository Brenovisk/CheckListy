//
//  DIContainer.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation

@MainActor
class DIContainer: ObservableObject {

    // Services / Data Sources
    let firebaseDatabase: FirebaseDatabase
    let firebaseAuthService: FirebaseAuthService
    let remoteImageDataSource: RemoteImageDataSource
    let localImageDataSource: LocalImageDataSource
    let feedbackService: FeedbackService
    let userService: UserService

    // Repositories
    let listsRepository: ListsRepositoryProtocol
    let userRepository: UserRepositoryProtocol

    // Use Cases
    let fetchListsUseCase: FetchListsUseCase
    let toggleFavoriteUseCase: ToggleFavoriteUseCase
    let updateListUseCase: UpdateListUseCase
    let deleteListUseCase: DeleteListUseCase
    let registerUserUseCase: RegisterUserUseCase
    let addSharedList: AddSharedList

    init() {
        self.firebaseDatabase = FirebaseDatabase()
        self.firebaseAuthService = FirebaseAuthService()
        self.remoteImageDataSource = RemoteImageDataSource()
        self.localImageDataSource = LocalImageDataSource()
        self.feedbackService = FeedbackService()
        
        self.userService = UserService(
            firebaseDatabase: firebaseDatabase,
            firebaseAuthService: firebaseAuthService
        )

        self.listsRepository = ListsRepository(firebaseDatabase: firebaseDatabase)
        self.userRepository = UserRepository(
            firebaseDatabase: firebaseDatabase,
            localImageDataSource: localImageDataSource,
            remoteImageDataSource: remoteImageDataSource
        )

        self.fetchListsUseCase = FetchListsUseCase(repository: listsRepository)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: listsRepository)
        self.updateListUseCase = UpdateListUseCase(repository: listsRepository)
        self.deleteListUseCase = DeleteListUseCase(repository: listsRepository)
        self.registerUserUseCase = RegisterUserUseCase(
            authService: firebaseAuthService,
            userRepository: userRepository,
            userService: userService
        )
        self.addSharedList = AddSharedList(listRepository: listsRepository, userRepository: userRepository)
    }
}
