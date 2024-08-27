//
//  AppDestination.swift
//  CheckListy
//
//  Created by Breno Lucas on 24/07/24.
//

import Foundation

enum AppDestination: Hashable {
    
    case detailsListView(list: ListModel)
    case profileView
    
}

enum AppDestinationAuth: Hashable {
    
    case signUpView
    case signUpAddPhotoView
    case signUpCreatePasswordView
    case forgotPasswordView(String)
    
}
