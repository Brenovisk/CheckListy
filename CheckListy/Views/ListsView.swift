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
        VStack {
            List {
                ForEach(viewModel.lists, id: \.self) { item in
                    if let item {
                        NavigationLink(destination: DetailsListView().environmentObject(DetailsListViewModel(item))) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color(item.color))
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: item.icon)             .foregroundColor(Color.black)
                                        .font(.system(size: 16))
                                }
                                Text(item.name)
                            }
                        }
                    }
                }.onDelete() { offset in 
                    viewModel.delete(at: offset)
                }
            }
        }
        .navigationTitle("Listas")
        .toolbar {
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
            FormListView(item: Binding.constant(nil))
                .onSave() { newList in
                    viewModel.create(list: newList)
                }
                .onClose() {
                    showCreateListForm.toggle()
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
