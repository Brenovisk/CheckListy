//
//  WelcomeView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/07/24.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var userName: String
    var uiImage: UIImage?

    var body: some View {
        HStack(spacing: 4) {
            Text(userName.isEmpty ? "Bem-vindo!" : "Bem-vindo, \(userName)!")
                .lineLimit(1)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .padding(12)
                    .background(Color.accentColor)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
