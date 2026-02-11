//
//  DeleteAccountView.swift
//  CheckListy
//
//  Created by Breno Lucas on 29/08/24.
//

import SwiftUI

struct DeleteAccountView: View {

    @StateObject var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            MessageWithImageView(
                image: image,
                title: TextsHelper.deleteAccount.rawValue,
                description: TextsHelper.deleteAccountDescription.rawValue
            )

            TextFieldCustom(
                text: $viewModel.dataForm.password,
                placeholder: TextsHelper.password.rawValue,
                helperText: viewModel.dataForm.passwordError,
                onChanged: { viewModel.dataForm.passwordError = nil },
                isSecureTextfield: true
            )

            Button(action: {
                guard viewModel.dataForm.isValid() else { return }
                viewModel.removeUserData()
            }) {
                Text(TextsHelper.erase.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton(isLoading: $viewModel.isLoading)
        }
        .padding(.horizontal, 16)
        .scrollable {}
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
    }

    var image: some View {
        ImagesHelper.deleteAccountVector.image
            .resizable()
            .frame(width: 250, height: 250)
    }

}
