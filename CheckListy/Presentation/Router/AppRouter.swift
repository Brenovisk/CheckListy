//
//  AppRouter.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case splash
    case auth
    case main
    case details(ListModel)
    case profile
    case deleteAccount
    case signUp
    case forgotPassword(String?)
    case forgotPasswordConfirmation
    case signUpAddPhoto(SignUpViewModel)
    case signUpCreatePassword(SignUpViewModel)
}

@MainActor
class AppRouter: ObservableObject {
    
    let container: DIContainer
    
    @Published var path = NavigationPath()
    @Published var root: AppRoute = .splash
    
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        bindAuthState()
    }
    
    private func bindAuthState() {
        container.firebaseAuthService.$isSignIn
            .receive(on: RunLoop.main)
            .sink { [weak self] isSignIn in
                guard let self = self else { return }
                if let isSignIn = isSignIn {
                    self.root = isSignIn ? .main : .auth
                    self.path = NavigationPath() // Reset stack on root change
                } else {
                    self.root = .splash
                }
            }
            .store(in: &cancellables)
    }
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func view(for route: AppRoute) -> some View {
        switch route {
        case .splash:
            SplashView(expand: true)
        case .auth:
            let viewModel = SignInViewModel(
                router: self,
                authService: container.firebaseAuthService,
                userRepository: container.userRepository,
                userService: container.userService
            )
            AuthenticationView(viewModel: viewModel)
        case .main:
            let viewModel = ListsViewModel(
                router: self,
                authService: container.firebaseAuthService,
                fetchListsUseCase: container.fetchListsUseCase,
                toggleFavoriteUseCase: container.toggleFavoriteUseCase,
                updateListUseCase: container.updateListUseCase,
                deleteListUseCase: container.deleteListUseCase,
                userRepository: container.userRepository
            )
            MainView(viewModel: viewModel)
        case .details(let list):
            let viewModel = DetailsListViewModel(list, router: self, repository: container.listsRepository)
            DetailsListView(viewModel: viewModel)
        case .profile:
            let viewModel = ProfileViewModel(
                router: self,
                authService: container.firebaseAuthService,
                userRepository: container.userRepository,
                userService: container.userService
            )
            ProfileView(viewModel: viewModel)
        case .deleteAccount:
            let viewModel = ProfileViewModel(
                router: self,
                authService: container.firebaseAuthService,
                userRepository: container.userRepository,
                userService: container.userService
            )
            DeleteAccountView(viewModel: viewModel)
        case .signUp:
            let viewModel = SignUpViewModel(router: self, registerUserUseCase: container.registerUserUseCase)
            SignUpView().environmentObject(viewModel)
        case .forgotPassword(let email):
            let viewModel = {
                let vm = ForgotPasswordViewModel(router: self, authService: container.firebaseAuthService)
                vm.dataForm.email = email ?? ""
                return vm
            }()
            ForgotPasswordView(viewModel: viewModel)
        case .forgotPasswordConfirmation:
            ForgotPasswordConfirmationView()
        case .signUpAddPhoto(let vm):
            SignUpAddPhotoView().environmentObject(vm)
        case .signUpCreatePassword(let vm):
            SignUpCreatePasswordView().environmentObject(vm)
        }
    }
}
