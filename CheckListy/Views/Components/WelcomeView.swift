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
    var numberOfList: Int = 0

    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let uiImage {
                    Image(uiImage: uiImage)
                } else {
                    Image(systemName: "person.fill")
                }
            }
            .profileImage()

            VStack(alignment: .leading) {
                Text(userName.isEmpty ? "\(greeting)!" : "\(greeting), \(userName)!")
                    .lineLimit(1)
                    .font(.headline)

                if numberOfList > 0 {
                    Text("Você tem \(numberOfList) listas incompletas")
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.leading, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

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

}
