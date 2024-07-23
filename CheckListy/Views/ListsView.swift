//
//  ListsView.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation
import SwiftUI

struct ListsView: View {
    
    @EnvironmentObject var viewModel: ListsViewModel
    @State var showCreateListForm: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleIcon(title: "Minhas Listas", subtitle: "\(viewModel.lists.count)")
            
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
        }.navigationDestination(for: ListModel.self) { list in
            DetailsListView().environmentObject(DetailsListViewModel(list))
        }
    }
    
}

#Preview {
    NavigationView {
        ListsView()
            .environmentObject(ListsViewModel())
    }
}
