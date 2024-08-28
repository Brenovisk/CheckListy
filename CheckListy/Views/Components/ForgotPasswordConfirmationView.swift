//
//  ForgotPasswordConfirmationView.swift
//  CheckListy
//
//  Created by Breno Lucas on 28/08/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordConfirmationView: View {

    @EnvironmentObject private var viewModel: ForgotPasswordViewModel
    @State var isShowKeyboard = false

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            Images.messageReceivedVector.image

            VStack(spacing: 12) {
                Texts.sentEmail.value
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Texts.sentEmailDescription.value
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Button(action: {
                viewModel.navigateToLogin()
            }) {
                Text(Texts.login.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton()
        }
        .toolbar(.visible, for: .navigationBar)
        .padding(.horizontal, 16)
        .padding(.bottom, 64)
        .frame(maxHeight: .infinity, alignment: .center)
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 550)
    }

}

// MARK: typealias

extension ForgotPasswordConfirmationView {

    typealias Texts = TextsHelper
    typealias Images = ImagesHelper

}

#Preview {
    NavigationStack {
        ForgotPasswordConfirmationView()
            .environmentObject(ForgotPasswordViewModel())
    }
}
