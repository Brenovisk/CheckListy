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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TitleIcon(title: "Minhas Listas", subtitle: "\(viewModel.lists.count)")
            
            if !viewModel.recentsSection.items.isEmpty {
                Section(header:
                    HeaderSection(section: viewModel.recentsSection, enableAdd: false)
                        .onCollapse { section in
                            viewModel.toggleCollapseRecentSection()
                        }
                ) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($viewModel.recentsSection.items, id: \.self) { listId in
                                if let list = viewModel.getList(by: listId.wrappedValue) {
                                    ListCard(list: list, mode: Binding.constant(.grid))
                                        .onEdit { list in
                                            handleEdit(list)
                                        }
                                        .onDelete { list in
                                            handleDelete(list)
                                        }
                                        .onRedirect { list in
                                            handleRedirect(list)
                                        }
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 2 : 4, spacing: 16)
                                }
                            }
                        }
                    }
                    .contentMargins(.horizontal, 16, for: .scrollContent)
                    .collapse(isCollapsed: viewModel.recentsSection.collapsed)
                }
            }
            
            ForEach(viewModel.lists, id: \.self) { list in
                if let list {
                    ListCard(list: list, mode: $viewModel.visualizationMode)
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
                .onSave() { newList in
                    viewModel.create(list: newList)
                }
                .onClose() {
                    showCreateListForm.toggle()
                }
        }
        .onAppear {
            viewModel.recentsSection.items = viewModel.getRecents()
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
}

#Preview {
    NavigationView {
        ListsView()
            .environmentObject(ListsViewModel())
    }
}
