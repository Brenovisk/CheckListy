//
//  ListsView.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation
import SwiftUI

struct ListsView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var viewModel: ListsViewModel
    
    @State var showCreateListForm: Bool = false
    @State var showSheetShare: Bool = false
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WelcomeView(
                userName: viewModel.userName ?? String(),
                uiImage: viewModel.userImage
            )
            .task {
                viewModel.getUserName()
                await viewModel.getUserImage()
            }
            .padding(.top, 8)
            .onTapGesture {
                NavigationService.shared.navigateTo(.profileView)
            }
            
            TitleIcon(title: "Minhas Listas", subtitle: "\(viewModel.lists.count)").padding(.bottom, 24)
            
            if viewModel.showSearchBar {
                AutoFocusTextField(text: $viewModel.searchText, placeholder: "Pesquisar...")
                    .roundedBackgroundTextField()
                    .padding(.bottom, 24)
            }
            
            if !viewModel.recentsSection.items.isEmpty && !viewModel.showSearchBar {
                Section(header: recentsHeaderSection) {
                    ForEach($viewModel.recentsSection.items, id: \.self) { listId in
                        if let list = viewModel.getList(by: listId.wrappedValue) {
                            card(list, visualization: Binding.constant(.grid))
                                .containerRelativeHorizontal()
                        }
                    }
                    .scrollHorizontal()
                    .collapse(isCollapsed: viewModel.recentsSection.collapsed)
                }.padding(.bottom, viewModel.recentsSection.collapsed ? 0 : 16 )
            }
            
            if !viewModel.favorites.isEmpty && !viewModel.showSearchBar {
                Section(header: favoritesHeaderSection) {
                    ForEach(viewModel.favorites, id: \.self) { list in
                        card(list, visualization: Binding.constant(.grid))
                            .containerRelativeHorizontal()
                    }
                    .scrollHorizontal()
                    .collapse(isCollapsed: viewModel.favoritesSection.collapsed)
                }.padding(.bottom, viewModel.favoritesSection.collapsed ? 0 : 16 )
            }
            
            ForEach(viewModel.getLists(), id: \.self) { list in
                if let list {
                    card(list, visualization: $viewModel.visualizationMode)
                }
            }
            .grid(enable: $viewModel.visualizationMode)
        }
        .scrollable {
            TitleIcon(
                title: "Minhas Listas",
                iconSize: 10,
                subtitle: "\(viewModel.lists.count)"
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                SearchButton(isEnable: $viewModel.showSearchBar)
                    .onEnable {
                        viewModel.toggleSearchBar()
                    }
            }
            
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { viewModel.toggleVisualization() }) {
                    Image(systemName: viewModel.visualizationMode == .list ?  "rectangle.grid.1x2" : "square.grid.2x2")
                }
            }
            
            ToolbarItemGroup(placement: .secondaryAction) {
                Button(action: { viewModel.signOut() }) {
                    Text("Sair")
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    Button(action: {
                        viewModel.listToEdit = nil
                        showCreateListForm.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Adicionar Lista")
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .sheet(isPresented: $showCreateListForm) {
            FormListView(item: $viewModel.listToEdit)
                .onSave { newList in
                    if viewModel.listToEdit != nil {
                        viewModel.update(list: newList)
                        return
                    }
                    viewModel.create(list: newList)
                }
                .onClose {
                    showCreateListForm.toggle()
                }
                .onSaveByCode { code in
                    viewModel.add(by: code)
                }
        }
        .sheet(isPresented: $showSheetShare) {
            ShareSheet(items: viewModel.contentToShare)
        }
        .onAppear {
            viewModel.recentsSection.items = viewModel.getRecents()
        }.onChange(of: verticalSizeClass) {
            viewModel.setVisualizationMode(according: verticalSizeClass)
           
        }
    }
    
    var recentsHeaderSection: some View {
        HeaderSection(
            section: viewModel.recentsSection,
            icon: "clock",
            enableAdd: false
        ).onCollapse { section in
             viewModel.toggleCollapseRecentSection()
        }
    }
    
    var favoritesHeaderSection: some View {
        HeaderSection(
            section: viewModel.favoritesSection,
            icon: "star",
            enableAdd: false
        ).onCollapse { section in
             viewModel.toggleCollapseFavoritesSection()
        }
    }
    
    func card(_ list: ListModel, visualization: (Binding<ListMode>)? = nil) -> some View {
        ListCard(list: list, mode: visualization)
            .onEdit { list in
                viewModel.listToEdit = list
                showCreateListForm = true
            }
            .onDelete { list in
                viewModel.delete(list: list)
            }
            .onRedirect { list in
                handleRedirect(list)
            }
            .onFavorite { list in
                handleOnFavorite(list)
            }
            .onShare { list in
                handleOnShare(list)
            }
    }
    
    func handleEdit(_ list: ListModel) {
        withAnimation {
            viewModel.listToEdit = list
            showCreateListForm = true
        }
    }
    
    func handleDelete(_ list: ListModel) {
        withAnimation {
            viewModel.delete(list: list)
        }
    }
    
    func handleRedirect(_ list: ListModel) {
        NavigationService.shared.navigateTo(.detailsListView(list: list))
    }
    
    func handleOnFavorite(_ list: ListModel) {
        withAnimation {
            viewModel.toggleIsFavorite(to: list)
        }
    }
    
    func handleOnShare(_ list: ListModel) {
        withAnimation {
            withAnimation {
                viewModel.setContentToShared(to: list)
                showSheetShare = true
            }
        }
    }
}

#Preview {
    NavigationView {
        ListsView()
            .environmentObject(ListsViewModel())
    }
}
