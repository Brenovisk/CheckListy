//
//  TextsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

// swiftformat:disable consecutiveSpaces
enum TextsHelper: String {

    case slogan                           = "Transforme sua rotina diaria em uma sinfonia de produtividade e motivação."
    case start                            = "Começar"
    case notHaveAccount                   = "Ainda não tem conta?"
    case registerYourSelf                 = "Registre-se"
    case login                            = "Login"
    case plaseInsertEmail                 = "Por favor, insira seu e-mail e senha para acessar sua conta"
    case signInToYourAccount              = "Entre na sua conta"
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
    case accountExistsDifferentCredential = "A conta já existe com o mesmo endereço de e-mail, mas com diferentes credenciais de autenticação. Faça login usando um provedor associado a este endereço de e-mail" // swiftlint:disable:this line_length
    case requiresRecentLogin              = "Esta operação é sensível e requer uma autenticação recente. Faça login novamente antes de tentar novamente esta solicitação" // swiftlint:disable:this line_length
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
    case choosePhotoDescription           = "Escolha uma foto da galeria para personalizar seu perfil. Se preferir, você pode continuar e adicionar mais tarde." // swiftlint:disable:this line_length
    case createASecurePassword            = "Crie uma Senha Segura"
    case createASecureDescription         = "Lembre-se de usar uma combinação de letras, números e caracteres especiais para maior segurança."
    case confirmPassword                  = "Confirme sua senha"
    case create                           = "Criar"
    case recoverPassword                  = "Recuperar Senha"
    case recoverPasswordDescription       = "Insira seu e-mail abaixo para receber instruções sobre como redefinir sua senha. Você receberá um e-mail com o passo a passo" // swiftlint:disable:this line_length
    case send                             = "Enviar"
    case sentEmail                        = "Email enviado!"
    case sentEmailDescription             = "Um e-mail foi enviado com as instruções para redefinir sua senha. Após concluir o processo, você poderá fazer login novamente." // swiftlint:disable:this line_length
    case deleteAccount                    = "Deseja apagar seus dados?"
    case deleteAccountDescription         = "Ao continuar, sua conta, incluindo suas listas, foto de perfil e dados de acesso, serão apagados.. Se tiver certeza e estiver pronto para seguir em frente, por favor, insira sua senha para confirmar. Lembre-se, essa decisão é permanente." // swiftlint:disable:this line_length
    case erase                            = "Apagar"
    case emptyLists                       = "Sem Listas Ainda?"
    case emptyListsDescription            = "Parece que você ainda não adicionou nenhuma lista. Comece a organizar suas tarefas agora mesmo clicando no botão abaixo!" // swiftlint:disable:this line_length
    case myLists                          = "Minhas Listas"
    case search                           = "Pesquisar..."
    case addList                          = "Adicionar Lista"
    case all                              = "Todas"
    case favorites                        = "Favoritos"
    case incompletes                      = "Incompletas"
    case completes                        = "Completas"
    case or                               = "Ou" // swiftlint:disable:this line_length
    case signInWithGoogle                 = "Continue com o Google"
    case signInWithApple                  = "Continue com a Apple"

}

extension TextsHelper {

    var value: Text {
        Text(rawValue)
    }

}
