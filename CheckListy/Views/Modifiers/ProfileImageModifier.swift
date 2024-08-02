//
//  ProfileImageModifier.swift
//  CheckListy
//
//  Created by Breno Lucas on 01/08/24.
//

import Foundation
import SwiftUI

struct ProfileImageModifier: ViewModifier {
    
    var size: CGFloat = 40
    
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
    
}

extension View {
    
    func profileImage(_ size: CGFloat = 40) -> some View {
        self.modifier(ProfileImageModifier(size: size))
    }
    
}
