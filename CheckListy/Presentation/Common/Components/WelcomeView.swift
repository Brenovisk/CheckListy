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
    var numberOfList: Int?

    var greeting: String {
        let period = TimeService.getPeriodDay()

        switch period {
        case .morning:
            return "Bom dia"
        case .afternoon:
            return "Boa tarde"
        case .evening:
            return "Boa noite"
        case .night:
            return "Boa madrugada"
        }
    }

    var subtitle: String {
        guard let numberOfList else { return "Bem-vindo ao CheckListy!" }

        switch numberOfList {
        case let value where value > 0:
            return "Você tem \(numberOfList) listas incompletas"
        default:
            return "Todas as listas estão completas!"
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            image
                .profileImage()

            VStack(alignment: .leading) {
                Text(userName.isEmpty ? "\(greeting)" : "\(greeting), \(userName)")
                    .lineLimit(1)
                    .font(.headline)

                Text(subtitle)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.leading, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var image: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            IconsHelper.personFill.value
        }
    }

}
