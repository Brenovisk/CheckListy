//
//  MessageWithImageView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import Foundation
import SwiftUI

struct MessageWithImageView: View {

    var image: Image
    var title: String
    var description: String
    var buttonText: String?
    var onAction: (() -> Void)?

    private init(
        image: Image,
        title: String,
        description: String,
        buttonText: String?,
        onAction: (() -> Void)?
    ) {
        self.init(
            image: image,
            title: title,
            description: description,
            buttonText: buttonText
        )
        self.onAction = onAction
    }

    init(image: Image, title: String, description: String, buttonText: String?) {
        self.image = image
        self.title = title
        self.description = description
        self.buttonText = buttonText
    }

    var body: some View {
        VStack(spacing: 24) {
            image

            VStack(spacing: 12) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            if let onAction {
                Button(action: { onAction() }) {
                    Text(buttonText ?? "Action")
                        .frame(maxWidth: .infinity)
                }
                .filledButton()
            }
        }
    }

}

// MARK: - Callbacks modifiers
extension MessageWithImageView {

    func onAction(action: (() -> Void)?) -> MessageWithImageView {
        MessageWithImageView(
            image: image,
            title: title,
            description: description,
            buttonText: buttonText,
            onAction: action
        )
    }

}

#Preview {
    MessageWithImageView(
        image: ImagesHelper.messageReceivedVector.image,
        title: "Success!",
        description: "Your operation was completed successfully.",
        buttonText: "Continue"
    )
    .onAction {
        print("Button tapped")
    }
}
