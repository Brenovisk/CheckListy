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
    @State private var listCode: String = .init()
    @State private var selectedColor: String
    @State private var selectedIcon: String
    @State private var items: [ListItemModel]
    @State private var showAddListByCode: Bool = false

    let layoutIcon = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var onSave: ((ListModel) -> Void)?
    var onSaveByCode: ((String) -> Void)?
    var onClose: (() -> Void)?

    let colors: [String] = ["red-app", "green-app", "blue-app", "yellow-app", "purple-app"]

    let icons: [String] = [
        "house.fill",
        "star.fill",
        "bell.fill",
        "heart.fill",
        "flag.fill",
        "book.fill",
        "folder.fill",
        "flame.fill",
        "bolt.fill",
        "leaf.fill"
    ]

    private init(item: Binding<ListModel?>, onSave: ((ListModel) -> Void)?, onClose: (() -> Void)?, onSaveByCode: ((String) -> Void)?) {
        self.init(item: item)
        self.onSave = onSave
        self.onClose = onClose
        self.onSaveByCode = onSaveByCode

        UITextField.appearance().clearButtonMode = .whileEditing
    }

    init(item: Binding<ListModel?>) {
        _item = item
        _id = State(initialValue: item.wrappedValue?.id ?? UUID())
        _name = State(initialValue: item.wrappedValue?.name ?? "")
        _selectedColor = State(initialValue: item.wrappedValue?.color ?? "red-app")
        _selectedIcon = State(initialValue: item.wrappedValue?.icon ?? "house")
        _items = State(initialValue: item.wrappedValue?.items ?? [])
    }

    var body: some View {
        NavigationView {
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

                    Toggle(isOn: $showAddListByCode) {
                        Text("Adicionar lista por código")
                            .foregroundColor(.secondary)
                    }

                    if showAddListByCode {
                        TextField("Código", text: $listCode)
                    }
                }
                .navigationTitle(item == nil ? "Adicionar Lista" : "Editar Lista")
                .navigationBarItems(
                    leading: Button(action: { onClose?() }) {
                        Text("Cancelar")
                    },
                    trailing:
                    Button(action: {
                        guard let user = try? FirebaseAuthService.shared.getAuthUser() else { return }
                        if listCode.isEmpty {
                            let newItem = ListModel(
                                id: id,
                                name: name,
                                color: selectedColor,
                                icon: selectedIcon,
                                items: items,
                                createdAt: item?.createdAt ?? Date(),
                                editedAt: Date(),
                                users: item?.users ?? [user.uid]
                            )

                            onSave?(newItem)
                        } else {
                            onSaveByCode?(listCode)
                        }
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
    func onSave(action: ((ListModel) -> Void)?) -> FormListView {
        FormListView(
            item: $item,
            onSave: action,
            onClose: onClose,
            onSaveByCode: onSaveByCode
        )
    }

    func onClose(action: (() -> Void)?) -> FormListView {
        FormListView(
            item: $item,
            onSave: onSave,
            onClose: action,
            onSaveByCode: onSaveByCode
        )
    }

    func onSaveByCode(action: ((String) -> Void)?) -> FormListView {
        FormListView(
            item: $item,
            onSave: onSave,
            onClose: onClose,
            onSaveByCode: action
        )
    }

}

#Preview {
    NavigationView {
        FormListView(item: Binding.constant(nil))
    }
}
