//
//  ColorsHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import Foundation
import SwiftUI

enum ColorsHelper: String {
    case background
}

extension ColorsHelper {
    var value: Color {
        Color(rawValue)
    }
}
