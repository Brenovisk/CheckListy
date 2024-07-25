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
    
    private init() {}
    
    func navigateTo(_ destination: AppDestination) {
        navigationPath.append(destination)
    }
    
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
    }
    
}
