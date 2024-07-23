//
//  ListCard.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import Foundation
import SwiftUI

struct ListCard: View {
    
    var list: ListModel
    @Binding var mode: ListMode
    
    @Environment(\.colorScheme) var colorScheme
    
    var onEdit: ((ListModel) -> Void)?
    var onDelete: ((ListModel) -> Void)?
    var onRedirect: ((ListModel) -> Void)?
    
    private init(list: ListModel, mode: (Binding<ListMode>)? = nil, onEdit: ((ListModel) -> Void)?, onDelete: ((ListModel) -> Void)?, onRedirect: ((ListModel) -> Void)?) {
        self.init(list: list, mode: mode)
        
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onRedirect = onRedirect
    }
    
    init(list: ListModel, mode:(Binding<ListMode>)? = nil) {
        self.list = list
        self._mode = mode ?? Binding.constant(.grid)
    }
    
    var body: some View {
        VStack {
            if mode == .list {
                listCard
            } else {
                gridCard
            }
            
            Spacer().frame(height: 8)
        }
    }
    
    var gridCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    NavigationLink(value: list) {
                        icon
                        
                        Spacer()
                    }
                    
                    menu
                }
                
                NavigationLink(value: list) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(list.name)
                                .font(.body)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            
                            if !list.description.isEmpty  {
                                Text(list.description)
                                    .font(.subheadline)
                                    .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                            }
                        }
                        
                        Spacer()
                        
                        checkedItems
                            .padding(.trailing, 12)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding([.leading, .vertical], 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    
    var listCard: some View {
        HStack {
            NavigationLink(value: list) {
                HStack(alignment: .center, spacing: .zero) {
                    icon
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        Text(list.name)
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        
                        if !list.description.isEmpty  {
                            Text(list.description)
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    checkedItems
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            menu
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var checkedItems: some View {
        Text(list.checkItems)
            .font(.body)
            .foregroundColor(Color(list.color))
            .fontWeight(.semibold)
    }
    
    
    var icon: some View {
        ZStack {
            Circle()
                .fill(Color(list.color))
                .frame(width: 32, height: 32)
            
            Image(systemName: list.icon)
                .foregroundColor(Color.black)
                .font(.system(size: 16))
        }
    }
    
    var menu: some View {
        Menu {
            Button(action: {
                self.onEdit?(list)
            }) {
                Label("Editar", systemImage: "pencil")
            }
            
            Button(action: {
                self.onDelete?(list)
            }) {
                Label("Deletar", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding()
                .font(.system(size: 16))
        }
    }
}

//MARK: - Callbacks modifiers
extension ListCard {
    
    func `onEdit`(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: self.list,
            mode: self.$mode,
            onEdit: action,
            onDelete: self.onDelete,
            onRedirect: self.onRedirect
        )
    }
    
    func `onDelete`(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: self.list,
            mode: self.$mode,
            onEdit: self.onEdit,
            onDelete: action,
            onRedirect: self.onRedirect
        )
    }
    
    func `onRedirect`(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: self.list,
            mode: self.$mode,
            onEdit: self.onEdit,
            onDelete: self.onDelete,
            onRedirect: action
        )
    }
    
}

#Preview {
    ListCard(
        list: ListModel(
            id: UUID(),
            name: "List Name",
            description: "List description",
            color: "red",
            icon: "house",
            items: []
        )
    )
}
