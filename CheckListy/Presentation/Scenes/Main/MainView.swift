//
//  MainView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var navigationService = NavigationService.shared
    @StateObject private var listsViewModel = ListsViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()

    var body: some View {
        NavigationStack(path: $navigationService.navigationPath) {
            ListsView()
                .environmentObject(listsViewModel)
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case let .detailsListView(list):
                        DetailsListView(viewModel: DetailsListViewModel(list))
                    case .profileView:
                        ProfileView()
                            .environmentObject(profileViewModel)
                    case .deleteAccountView:
                        DeleteAccountView()
                            .environmentObject(profileViewModel)
                    }
                }
        }
    }

}

#Preview {
    MainView()
}
