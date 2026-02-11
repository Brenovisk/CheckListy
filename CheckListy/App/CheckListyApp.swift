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
    @StateObject private var router = AppRouter.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                Group {
                    switch router.root {
                    case .main:
                        MainView()
                    case .auth:
                        AuthenticationView()
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
