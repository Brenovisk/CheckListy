//
//  SignUpView.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/07/24.
//

import Foundation
import SwiftUI

struct SignUpView: View, KeyboardReadable {

    @EnvironmentObject private var viewModel: SignUpViewModel

    @State var isShowKeyboard = false
    @State var scrollOffset: CGFloat = 0

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Texts.letsCreateYourAccount.value
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Texts.firsWeWannaKnowYou.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                TextFieldCustom(
                    text: $viewModel.dataForm.name,
                    placeholder: Texts.name.rawValue,
                    helperText: viewModel.dataForm.nameError,
                    onChanged: { viewModel.dataForm.nameError = nil },
                    isAutoFocused: true
                )

                TextFieldCustom(
                    text: $viewModel.dataForm.email,
                    placeholder: Texts.email.rawValue,
                    helperText: viewModel.dataForm.emailError,
                    onChanged: { viewModel.dataForm.emailError = nil }
                )
                .keyboardType(.emailAddress)
            }

            Button(action: {
                hideKeyboard()
                guard viewModel.dataForm.isValidEmailAndName() else { return }
                viewModel.navigateToSignUpAddPhotoView()
            }) {
                Text(Texts.goAhead.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton()
        }
        .toolbar(.visible, for: .navigationBar)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable(scrollOffset: $scrollOffset) {}
        .animatedBackground()
        .gradientTopDynamic(color: Color.accentColor, height: 164, scrollOffset: $scrollOffset)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }

}

// MARK: typealias
extension SignUpView {

    typealias Texts = TextsHelper

}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(SignUpViewModel())
    }
}
