//
//  IconsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 20/08/24.
//

import Foundation
import SwiftUI

enum IconsHelper: String {
    
    case eyeSlashFill = "eye.slash.fill"
    case eyeFill      = "eye.fill"
    
}

extension IconsHelper {
    
    var value: Image {
        Image(systemName: self.rawValue)
    }
    
}
