//
//  CheckListyApp.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import FirebaseCore
import SwiftUI

@main
struct CheckListyApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var container = DIContainer()
    @StateObject private var router: AppRouter
    
    init() {
        let container = DIContainer()
        _container = StateObject(wrappedValue: container)
        _router = StateObject(wrappedValue: AppRouter(container: container))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                Group {
                    switch router.root {
                    case .main:
                        MainView(viewModel: ListsViewModel(
                            router: router,
                            fetchListsUseCase: container.fetchListsUseCase,
                            toggleFavoriteUseCase: container.toggleFavoriteUseCase,
                            updateListUseCase: container.updateListUseCase,
                            userRepository: container.userRepository
                        ))
                    case .auth:
                        AuthenticationView(viewModel: SignInViewModel(router: router, authService: container.firebaseAuthService))
                    default:
                        SplashView()
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    router.view(for: route)
                }
            }
            .preferredColorScheme(.dark)
        }
    }

}
