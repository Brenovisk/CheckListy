//
//  LoginViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        // Simulação de um processo de login
        self.isLoading = true
        self.errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            
            if self.email.isEmpty || self.password.isEmpty {
                self.errorMessage = "Email e senha são obrigatórios."
            } else if self.email == "user@example.com" && self.password == "password" {
                self.errorMessage = nil
                print("Login bem-sucedido")
                // Aqui você pode navegar para outra tela ou fazer outra ação
            } else {
                self.errorMessage = "Credenciais inválidas."
            }
        }
    }
}
