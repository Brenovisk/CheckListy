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
            .foregroundColor(ColorsHelper.background.value)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 6.5)
            )
    }
}

extension View {
    func profileImage(_ size: CGFloat = 40) -> some View {
        modifier(ProfileImageModifier(size: size))
    }
}
