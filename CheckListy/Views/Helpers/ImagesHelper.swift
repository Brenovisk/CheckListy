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
    case coloredShapesBlackVector = "colored-shapes-black-vector"
    case messageReceivedVector = "message-received-vector"
    case deleteAccountVector = "delete-account-vector"
    case emptyListsVector = "empty-lists-vector"
    case googleIconVector = "google-icon-vector"
    case appleIconVector = "apple-icon-vector"

}

extension ImagesHelper {

    var image: Image {
        Image(rawValue)
    }

}
