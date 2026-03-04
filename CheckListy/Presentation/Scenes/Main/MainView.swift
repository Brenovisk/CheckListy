//
//  MainView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var listsViewModel: ListsViewModel
    
    init(viewModel: ListsViewModel) {
        _listsViewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ListsView()
            .environmentObject(listsViewModel)
    }

}

#Preview {
    let firebaseDatabase = FirebaseDatabase()
    let localImageDataSource = LocalImageDataSource()
    let remoteImageDataSource = RemoteImageDataSource()
    let repository = ListsRepository(firebaseDatabase: firebaseDatabase)
    let userRepository = UserRepository(
        firebaseDatabase: firebaseDatabase,
        localImageDataSource: localImageDataSource,
        remoteImageDataSource: remoteImageDataSource
    )
    
    return MainView(
        viewModel: ListsViewModel(
            router: AppRouter(container: DIContainer()),
            authService: FirebaseAuthService(),
            fetchListsUseCase: FetchListsUseCase(repository: repository),
            toggleFavoriteUseCase: ToggleFavoriteUseCase(repository: repository),
            updateListUseCase: UpdateListUseCase(repository: repository),
            deleteListUseCase: DeleteListUseCase(repository: repository),
            addSharedList: AddSharedList(listRepository: repository, userRepository: userRepository),
            userRepository: userRepository
        )
    )
}
