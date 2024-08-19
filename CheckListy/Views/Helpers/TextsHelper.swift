//
//  TextsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

enum TextsHelper: String {
    
    case slogan = "Transforme sua rotina diaria em uma sinfonia de produtividade e motivação."
    case start = "Começar"
    case notHaveAccount = "Ainda não tem conta?"
    case registerYourSelf = "Registre-se"
    
}

extension TextsHelper {
    
    var value: Text {
        Text(self.rawValue)
    }
    
}
