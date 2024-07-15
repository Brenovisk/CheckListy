//
//  FormListView.swift
//  CheckListy
//
//  Created by Breno Lucas on 10/07/24.
//

import Foundation
import SwiftUI

struct FormListView: View {
    
    @Binding var item: ListModel?
    @State private var id: UUID
    @State private var name: String
    @State private var selectedColor: String
    @State private var selectedIcon: String
    @State private var items: Array<ListItemModel>
    
    let layoutIcon = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var onSave: ((ListModel) -> Void)?
    var onClose: (() -> Void)?
    
    let colors: [String] = ["red", "green", "blue", "yellow", "purple"]
    let icons: [String] = ["house.fill", "star.fill", "bell.fill", "heart.fill", "flag.fill", "book.fill", "folder.fill", "flame.fill", "bolt.fill", "leaf.fill"]
    
    private init(item: Binding<ListModel?>, onSave: ((ListModel) -> Void)?, onClose: (() -> Void)?) {
        self.init(item: item)
        self.onSave = onSave
        self.onClose = onClose
    }
    
    init(item: Binding<ListModel?>) {
        self._item = item
        _id = State(initialValue: item.wrappedValue?.id ?? UUID())
        _name = State(initialValue: item.wrappedValue?.name ?? "")
        _selectedColor = State(initialValue: item.wrappedValue?.color ?? "red")
        _selectedIcon = State(initialValue: item.wrappedValue?.icon ?? "house")
        _items = State(initialValue: item.wrappedValue?.items ?? [])
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Nome")) {
                        TextField("Nome da Lista", text: $name)
                    }
                    
                    Section(header: Text("Cor")) {
                        LazyHStack(spacing: 24) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 30, height: 30)
                                    .padding(8)
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.accentColor : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    
                    Section(header: Text("Ícone")) {
                        ScrollView {
                            LazyHGrid(rows: layoutIcon, spacing: 24) {
                                ForEach(icons, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(.system(size: 24))
                                        .padding(8)
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                        .overlay(
                                            Circle()
                                                .stroke(selectedIcon == icon ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }.padding(.top, 16)
                    }
                }
                .navigationTitle(item == nil ? "Adicionar Lista" : "Editar Lista")
                .navigationBarItems(
                    leading: Button(action: { onClose?() }) {
                        Text("Cancelar")
                    },
                    trailing:
                        Button(action: {
                            let newItem = ListModel(
                                id: id,
                                name: name,
                                color: selectedColor,
                                icon: selectedIcon,
                                items: items
                            )
                            
                            onSave?(newItem)
                            onClose?()
                        }) {
                            Text(item == nil ? "Criar" : "Editar")
                        }
                )
                
            }
        }
    }
    
}

// MARK: - Callbacks modifiers
extension FormListView {
    
    func `onSave`(action: ((ListModel) -> Void)?) -> FormListView {
        FormListView(
            item: self.$item,
            onSave: action,
            onClose: self.onClose
        )
    } 
    
    func `onClose`(action: (() -> Void)?) -> FormListView {
        FormListView(
            item: self.$item,
            onSave: self.onSave,
            onClose: action
        )
    }
    
}

#Preview {
    NavigationView {
        FormListView(item: Binding.constant(nil))
    }
}
