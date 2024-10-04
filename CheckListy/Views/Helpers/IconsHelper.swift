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
    case eyeFill = "eye.fill"
    case personFill = "person.fill"
    case rectangleGrid1x2 = "rectangle.grid.1x2"
    case squareGrid1x2 = "square.grid.2x2"
    case clock
    case star
    case plus
    case listBullet = "list.bullet"
    case checkmark
    case xmark
    case calendar

}

extension IconsHelper {

    var value: Image {
        Image(systemName: rawValue)
    }

}
