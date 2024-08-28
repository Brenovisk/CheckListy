//
//  UserProfile.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import UIKit

class UserProfile: UserDatabase {
    var profileImage: UIImage?
    var email: String

    required init(id: String, name: String, urlProfileImage: URL? = nil, profileImage: UIImage? = nil, email: String = String()) {
        self.profileImage = profileImage
        self.email = email
        super.init(id: id, name: name, urlProfileImage: urlProfileImage)
    }

    required init(id: String, name: String, urlProfileImage: URL?) {
        profileImage = nil
        email = ""
        super.init(id: id, name: name, urlProfileImage: urlProfileImage)
    }

    convenience init(id: String, name: String, email: String) {
        self.init(id: id, name: name, urlProfileImage: nil, profileImage: nil, email: email)
    }
}
