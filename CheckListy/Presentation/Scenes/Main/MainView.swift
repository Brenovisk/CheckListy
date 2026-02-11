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
    // Preview mock/placeholder
    MainView(viewModel: ListsViewModel(
        router: AppRouter(container: DIContainer()),
        fetchListsUseCase: FetchListsUseCase(),
        toggleFavoriteUseCase: ToggleFavoriteUseCase(),
        updateListUseCase: UpdateListUseCase(),
        userRepository: UserRepository(
            firebaseDatabase: FirebaseDatabase(),
            localImageDataSource: LocalImageDataSource(),
            remoteImageDataSource: RemoteImageDataSource()
        )
    ))
}
