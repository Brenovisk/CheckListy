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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 24){
                TitleIcon(title: "Perfil")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: .zero) {
                    if let image = viewModel.userImage {
                        Image(uiImage: image)
                            .resizable()
                            .profileImage(60)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .padding(12)
                            .background(Color.accentColor)
                            .profileImage(54)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.userName)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text(viewModel.userEmail)
                            .font(.subheadline)
                            .foregroundStyle(Color(uiColor: UIColor.secondaryLabel))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    
                    Button(action: {}) {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .section()
                .task {
                    await viewModel.getUserData()
                }
                
                DefaultSection(title: "Geral") {
                    VStack(spacing: 16){
                        DefaultSectionOption(
                            title: "Mudar Senha",
                            icon: "lock",
                            navigable: true
                        ).onPress {
                            
                        }
                        
                        Divider()
                        
                        DefaultSectionOption(
                            title: "Apagar meus dados",
                            icon: "trash",
                            navigable: true,
                            destructive: true
                        ).onPress {
                            
                        }
                    }
                }
                
                DefaultSection(title: "Suporte") {
                    VStack(spacing: 16){
                        DefaultSectionOption(
                            title: "Precisa de Ajuda?",
                            icon: "message",
                            navigable: true
                        ).onPress {
                            
                        }
                        
                        Divider()
                        
                        DefaultSectionOption(
                            title: "Privacy Policy",
                            icon: "exclamationmark.circle",
                            navigable: true
                        ).onPress {
                            
                        }
                    }
                }
            }
            .scrollable{
                TitleIcon(
                    title: "Perfil",
                    iconSize: 10
                )
            }
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Finalizar Sessão")
                }.foregroundColor(.red)
            }
            .padding(.bottom, 16)
        }
    }
    
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(ProfileViewModel())
    }
}
