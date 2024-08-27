//
//  ColorsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

enum ColorsHelper: String {
    
    case background = "background" // swiftlint:disable:this redundant_string_enum_value 
    
}

extension ColorsHelper {
    
    var value: Color {
        Color(self.rawValue)
    }
    
}
