//
//  SignUpAddPhotoView .swift
//  CheckListy
//
//  Created by Breno Lucas on 22/08/24.
//

import SwiftUI

struct SignUpAddPhotoView: View, KeyboardReadable {
    @EnvironmentObject private var viewModel: SignUpViewModel

    @State var isShowKeyboard = false

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Texts.addProfilePhoto.value
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Texts.choosePhotoDescription.value
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                ImagePicker(image: nil)
                    .onPick { imageUrl in
                        viewModel.dataForm.uiImage = imageUrl
                    }
            }

            Button(action: {
                hideKeyboard()
                viewModel.navigateToSignUpCreatePassword()
            }) {
                Text(Texts.goAhead.rawValue)
                    .frame(maxWidth: .infinity)
            }
            .filledButton()
            .padding(.top, 8)
        }
        .toolbar(.visible, for: .navigationBar)
        .frame(maxHeight: .infinity, alignment: .top)
        .scrollable {}
        .animatedBackground()
        .gradientTop(color: Color.accentColor, height: 164)
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                isShowKeyboard = value
            }
        }
    }
}

// MARK: typealias

extension SignUpAddPhotoView {
    typealias Texts = TextsHelper
}

#Preview {
    NavigationStack {
        SignUpAddPhotoView()
            .environmentObject(SignUpViewModel())
    }
}
