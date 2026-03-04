//
//  UsersPhoto.swift
//  CheckListy
//
//  Created by Breno Lucas on 08/10/24.
//

import SwiftUI

struct UsersPhoto: View {

    let images: [UIImage]

    var body: some View {
        HStack(spacing: -8) {
            if images.count > 3 || images.isEmpty {
                IconsHelper.person2Fill.value
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(images.prefix(3).enumerated()), id: \.offset) { _, image in
                    Image(uiImage: image)
                        .resizable()
                        .profileImage(24, 2)
                }
            }
        }
    }

}
