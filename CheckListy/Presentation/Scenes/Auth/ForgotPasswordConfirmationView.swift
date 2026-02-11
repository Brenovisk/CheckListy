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
        MessageWithImageView(
            image: Images.messageReceivedVector.image,
            title: Texts.sentEmail.rawValue,
            description: Texts.sentEmailDescription.rawValue,
            buttonText: Texts.login.rawValue
        )
        .onAction {
            viewModel.navigateToLogin()
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
