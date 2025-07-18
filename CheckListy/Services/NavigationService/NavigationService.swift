//
//  NavigationService.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/07/24.
//

import Foundation
import SwiftUI

class NavigationService: ObservableObject {
    static let shared = NavigationService()

    @Published var navigationPath = NavigationPath()
    @Published var navigationPathAuth = NavigationPath()

    private init() {}

    func navigateTo(_ destination: AppDestination) {
        navigationPath.append(destination)
    }

    func navigateTo(_ destination: AppDestinationAuth) {
        navigationPathAuth.append(destination)
    }

    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func goBackAuth() {
        if !navigationPathAuth.isEmpty {
            navigationPathAuth.removeLast()
        }
    }

    func resetNavigation() {
        navigationPath.removeLast(navigationPath.count)
    }

    func resetNavigationAuth() {
        navigationPathAuth.removeLast(navigationPathAuth.count)
    }
}
