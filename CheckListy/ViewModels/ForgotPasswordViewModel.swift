//
//  ForgotPasswordViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 12/08/24.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(email: String) {
        self.email = email
    }
    
    func resetPassword() async {
        do {
            isLoading = true
            try await FirebaseAuthService.shared.resetPassword(with: email)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
}
