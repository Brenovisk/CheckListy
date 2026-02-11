//
//  ProfileView.swift
//  CheckListy
//
//  Created by Breno Lucas on 31/07/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    @State var isEditProfileForm: Bool = false
    @State var isEditPasswordForm: Bool = false
    @State var isExecutingFormAction: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 24) {
                TitleIcon(title: "Perfil")
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: .zero) {
                    if let image = viewModel.userDatabase?.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .profileImage(60)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .padding(12)
                            .background(Color.accentColor)
                            .profileImage(60)
                    }

                    VStack(alignment: .leading) {
                        Text(viewModel.userDatabase?.name ?? String())
                            .font(.headline)
                            .lineLimit(1)

                        Text(viewModel.userDatabase?.email ?? String())
                            .font(.subheadline)
                            .foregroundStyle(Color(uiColor: UIColor.secondaryLabel))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)

                    Button(action: { isEditProfileForm = true }) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .section()
                .task {
                    await viewModel.getUserDatabase()
                }

                DefaultSection(title: "Geral") {
                    VStack(spacing: 16) {
                        DefaultSectionOption(
                            title: "Mudar Senha",
                            icon: "lock",
                            navigable: true
                        ).onPress {
                            isEditPasswordForm = true
                        }

                        Divider()

                        DefaultSectionOption(
                            title: "Apagar meus dados",
                            icon: "trash",
                            navigable: true,
                            destructive: true
                        ).onPress {
                            viewModel.navigateToDeleteAccountView()
                        }
                    }
                }

                DefaultSection(title: "Suporte") {
                    VStack(spacing: 16) {
                        DefaultSectionOption(
                            title: "Precisa de Ajuda?",
                            icon: "message",
                            navigable: true
                        ).onPress {}

                        Divider()

                        DefaultSectionOption(
                            title: "Política de Privacidade",
                            icon: "exclamationmark.circle",
                            navigable: true
                        ).onPress {}
                    }
                }
            }
            .scrollable {
                TitleIcon(
                    title: "Perfil",
                    iconSize: 10
                )
            }

            Button(action: { viewModel.signOut() }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Finalizar Sessão")
                }
            }
            .padding(.bottom, 24)
        }
        .popup(isPresent: $viewModel.showPopup, data: viewModel.popupData)
        .sheet(isPresented: $isEditProfileForm) {
            FormUserDatabase(user: $viewModel.userDatabase, isLoading: $isExecutingFormAction)
                .onSave { userEdited in
                    Task {
                        isExecutingFormAction = true
                        try await viewModel.update(user: userEdited)
                        isExecutingFormAction = false
                        isEditProfileForm = false
                    }
                }
                .onClose {
                    isEditProfileForm = false
                }
        }
        .sheet(isPresented: $isEditPasswordForm) {
            FormChangeUserPassword(isLoading: $isExecutingFormAction)
                .onSave { oldPassword, newPassword in
                    Task {
                        isExecutingFormAction = true
                        try await viewModel.update(oldPassword, to: newPassword)
                        isEditPasswordForm = false
                        isExecutingFormAction = false
                    }
                }
                .onClose {
                    isEditPasswordForm = false
                }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(ProfileViewModel())
    }
}
