//
//  ImagesHelper.swift
//  CheckListy
//
//  Created by Breno Lucas on 19/08/24.
//

import SwiftUI

enum ImagesHelper: String {

    case logo = "logo-vector"
    case logoName = "name-vector"
    case photoBackground = "initial-photo-image"
    case coloredShapesVector = "colored-shapes-vector"
    case messageReceivedVector = "message-received-vector"
    case deleteAccountVector = "delete-account-vector"

}

extension ImagesHelper {

    var image: Image {
        Image(rawValue)
    }

}
