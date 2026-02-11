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

class AppRouter: ObservableObject {
    
    static let shared = AppRouter()
    
    @Published var path = NavigationPath()
    @Published var root: AppRoute = .splash
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        bindAuthState()
    }
    
    private func bindAuthState() {
        FirebaseAuthService.shared.$isSignIn
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
            SplashView()
        case .auth:
            AuthenticationView()
        case .main:
            MainView()
        case .details(let list):
            DetailsListView(viewModel: DetailsListViewModel(list))
        case .profile:
            ProfileView()
        case .deleteAccount:
            DeleteAccountView()
        case .signUp:
            SignUpView().environmentObject(SignUpViewModel())
        case .forgotPassword(let email):
            ForgotPasswordView(with: email ?? "")
        case .forgotPasswordConfirmation:
            ForgotPasswordConfirmationView()
        case .signUpAddPhoto(let vm):
            SignUpAddPhotoView().environmentObject(vm)
        case .signUpCreatePassword(let vm):
            SignUpCreatePasswordView().environmentObject(vm)
        }
    }
}
