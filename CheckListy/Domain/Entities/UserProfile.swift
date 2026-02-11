//
//  UserProfile.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation

struct UserProfile: Identifiable {
    var id: String
    var name: String
    var email: String = .init()
    var lists: [String] = []
    // URL or Local Path identifier can go here, 
    // but the actual Image object should be handled by Presentation/Repository
}
