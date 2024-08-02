//
//  ProfileViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    
    @Published var userImage: UIImage? = nil
    @Published var userName: String = "tes tes tes"
    @Published var userEmail: String = "easdfasdfasdfasd@gmail.com"
    
    @MainActor 
    func getUserData() async {
        getUserName()
        await getUserImage()
        getUserEmail()
    }
    
    @MainActor
    func getUserName() {
        self.userName = FirebaseAuthService.shared.getAuthUserName()
    }
    
    @MainActor
    func getUserImage() async {
        self.userImage = await FirebaseAuthService.shared.getAuthUserImage()
    }
    
    @MainActor 
    func getUserEmail() {
        self.userName = FirebaseAuthService.shared.getAuthUserEmail()
    }
    
}
