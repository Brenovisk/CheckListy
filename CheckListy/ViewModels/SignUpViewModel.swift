//
//  SignUpViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var name: String = ""
    @Published var uiImage: UIImage? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func signUp() async {
        do {
            isLoading = true
            try await FirebaseAuthService.shared.signUp(withEmail: email, password: password, name: name, uiImage: uiImage) { isDone in
                isLoading = isDone
            }
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
}
