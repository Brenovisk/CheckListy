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
    @StateObject private var firebaseAuthService = FirebaseAuthService.shared

    var body: some Scene {
        WindowGroup {
            content()
                .preferredColorScheme(.dark)
        }
    }

}

extension CheckListyApp {

    @ViewBuilder
    private func content() -> some View {
        switch firebaseAuthService.authenticationState {
        case .authenticated:
            MainView()
        case .unauthenticated:
            AuthenticationView()
        case .loading:
            ProgressView()
        }
    }

}
