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
    case emailInvalid                     = "Email inválido"
    case passwordMinLength                = "A senha deve ter no mínimo 6 caracteres"
    case requiredField                    = "Campo obrigartório"
    case letsCreateYourAccount            = "Vamos criar sua conta!"
    case firsWeWannaKnowYou               = "Primeiro gostaríamos de conhecer você melhor! Por favor, preencha seu nome e e-mail."
    case goAhead                          = "Continuar"
    case exceededMaxLimit                 = "Excedeu o limite máximo de caracteres"
    case differentValuesPassword          = "Senhas não correspondem"
    case name                             = "Nome"
    case addProfilePhoto                  = "Adicione uma Foto de Perfil"
    case choosePhotoDescription           = "Escolha uma foto da galeria para personalizar seu perfil. Se preferir, você pode continuar e adicionar mais tarde."
    case createASecurePassword            = "Crie uma Senha Segura"
    case createASecureDescription         = "Lembre-se de usar uma combinação de letras, números e caracteres especiais para maior segurança."
    case confirmPassword                  = "Confirme sua senha"
    case create                           = "Criar"

}

extension TextsHelper {
    
    var value: Text {
        Text(self.rawValue)
    }
    
}
