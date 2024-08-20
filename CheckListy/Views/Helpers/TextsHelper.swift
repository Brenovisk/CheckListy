//
//  TextsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

enum TextsHelper: String {
    
    case slogan                           = "Transforme sua rotina diaria em uma sinfonia de produtividade e motivação."
    case start                            = "Começar"
    case notHaveAccount                   = "Ainda não tem conta?"
    case registerYourSelf                 = "Registre-se"
    case login                            = "Login"
    case plaseInsertEmail                 = "Por favor, insira seu e-mail e senha para acessar sua conta"
    case email                            = "Email"
    case password                         = "Senha"
    case signIn                           = "Entrar"
    case forgotPassword                   = "Esqueci a senha"
    case done                             = "Concluído"
    case invalidCustomToken               = "O token personalizado fornecido é inválido"
    case customTokenMismatch              = "O token personalizado corresponde a outro público-alvo da sua aplicação"
    case invalidCredential                = "A credencial fornecida está malformada ou expirada"
    case userDisabled                     = "A conta de usuário foi desativada pelo administrador"
    case operationNotAllowed              = "Este tipo de operação ainda não é permitido"
    case emailAlreadyInUse                = "O endereço de e-mail já está sendo usado por outra conta"
    case invalidEmail                     = "O endereço de e-mail está malformado"
    case wrongPassword                    = "A senha é inválida ou o usuário não tem uma senha"
    case tooManyRequests                  = "Muitas tentativas de login foram feitas muito recentemente. Tente novamente mais tarde"
    case userNotFound                     = "Não há registro de usuário correspondente a este identificador. O usuário pode ter sido excluído"
    case accountExistsDifferentCredential = "A conta já existe com o mesmo endereço de e-mail, mas com diferentes credenciais de autenticação. Faça login usando um provedor associado a este endereço de e-mail"
    case requiresRecentLogin              = "Esta operação é sensível e requer uma autenticação recente. Faça login novamente antes de tentar novamente esta solicitação"
    case providerAlreadyLinked            = "Esta conta já está associada a outro usuário"
    case noSuchProvider                   = "Não existe nenhum provedor de autenticação associado com o email fornecido"
    case invalidUserToken                 = "O token do usuário é inválido, talvez o usuário tenha sido excluído"
    case userTokenExpired                 = "O token do usuário expirou"
    case genericError                     = "Erro na operação"
    case interactionCancelledByUser       = "A interação foi cancelada pelo usuário"
    case noUserRegisteredWithThisNumber   = "Nenhum usuário cadastrado com esse número"

    
}

extension TextsHelper {
    
    var value: Text {
        Text(self.rawValue)
    }
    
}
