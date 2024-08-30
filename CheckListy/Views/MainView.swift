//
//  MainView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import SwiftUI

struct MainView: View {

    @StateObject private var navigationService = NavigationService.shared

    var body: some View {
        NavigationStack(path: $navigationService.navigationPath) {
            ListsView()
                .environmentObject(ListsViewModel())
                .navigationDestination(for: AppDestination.self) { destination in
                    switch destination {
                    case let .detailsListView(list):
                        DetailsListView()
                            .environmentObject(DetailsListViewModel(list))
                    case .profileView:
                        ProfileView()
                            .environmentObject(ProfileViewModel())
                    }
                }
        }
    }

}

#Preview {
    MainView()
}
