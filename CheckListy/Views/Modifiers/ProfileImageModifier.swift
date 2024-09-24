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
    var borderLineWidth: CGFloat = 4

    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .foregroundColor(ColorsHelper.background.value)
            .frame(width: size, height: size)
            .background(Color.accentColor)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: borderLineWidth)
            )
    }

}

extension View {
    func profileImage(_ size: CGFloat = 40, _ borderLineWidth: CGFloat = 4) -> some View {
        modifier(ProfileImageModifier(size: size, borderLineWidth: borderLineWidth))
    }
}
