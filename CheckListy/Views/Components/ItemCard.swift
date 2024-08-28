//
//  ItemCard.swift
//  CheckListy
//
//  Created by Breno Lucas on 15/07/24.
//

import Foundation
import SwiftUI

struct ItemCard: View {
    var item: ListItemModel
    var list: ListModel
    var sections: [SectionModel<ListItemModel>]

    @Environment(\.colorScheme) var colorScheme

    var onEdit: ((ListItemModel) -> Void)?
    var onDelete: ((ListItemModel) -> Void)?
    var onCheck: ((ListItemModel) -> Void)?
    var onMove: ((ListItemModel, SectionModel<ListItemModel>) -> Void)?

    private init(item: ListItemModel, list: ListModel, sections: [SectionModel<ListItemModel>], onEdit: ((ListItemModel) -> Void)?, onDelete: ((ListItemModel) -> Void)?, onMove: ((ListItemModel, SectionModel<ListItemModel>) -> Void)?, onCheck: ((ListItemModel) -> Void)?) {
        self.init(item: item, list: list, sections: sections)

        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onCheck = onCheck
        self.onMove = onMove
    }

    init(item: ListItemModel, list: ListModel, sections: [SectionModel<ListItemModel>]) {
        self.item = item
        self.list = list
        self.sections = sections
    }

    var body: some View {
        VStack {
            HStack {
                HStack(alignment: .center, spacing: .zero) {
                    Image(systemName: item.isCheck ? "circle.fill" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(list.color))
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            self.onCheck?(item)
                        }

                    VStack(alignment: .leading) {
                        Text(item.name)
                            .strikethrough(item.isCheck)
                            .opacity(item.isCheck ? 0.5 : 1.0)
                            .lineLimit(1)
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                        if !item.description.isEmpty {
                            Text(item.description)
                                .lineLimit(1)
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? Color(.lightGray) : Color(.darkGray))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .onTapGesture {
                        self.onEdit?(item)
                    }
                }
                .padding(.vertical, 4)

                Menu {
                    Button(role: .destructive, action: { self.onDelete?(item) }) {
                        Label("Deletar", systemImage: "trash")
                    }

                    Button(action: {
                        self.onEdit?(item)
                    }) {
                        Label("Editar", systemImage: "pencil")
                    }

                    if isShowMoveButton {
                        Menu("Mover para...") {
                            ForEach(sections, id: \.id) { section in
                                if !section.name.isEmpty {
                                    Button(action: {
                                        self.onMove?(item, section)
                                    }) {
                                        Text(section.name)
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding()
                        .font(.system(size: 16))
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)

            Spacer()
                .frame(height: 8)
        }
    }
}

// MARK: - Helper methods

extension ItemCard {
    var isShowMoveButton: Bool {
        let sectionWithName = sections.filter { !$0.name.isEmpty }
        return sectionWithName.count > 1
    }
}

// MARK: - Callbacks modifiers

extension ItemCard {
    func onCheck(action: ((ListItemModel) -> Void)?) -> ItemCard {
        ItemCard(
            item: item,
            list: list,
            sections: sections,
            onEdit: onEdit,
            onDelete: onDelete,
            onMove: onMove,
            onCheck: action
        )
    }

    func onEdit(action: ((ListItemModel) -> Void)?) -> ItemCard {
        ItemCard(
            item: item,
            list: list,
            sections: sections,
            onEdit: action,
            onDelete: onDelete,
            onMove: onMove,
            onCheck: onCheck
        )
    }

    func onDelete(action: ((ListItemModel) -> Void)?) -> ItemCard {
        ItemCard(
            item: item,
            list: list,
            sections: sections,
            onEdit: onEdit,
            onDelete: action,
            onMove: onMove,
            onCheck: onCheck
        )
    }

    func onMove(action: ((ListItemModel, SectionModel<ListItemModel>) -> Void)?) -> ItemCard {
        ItemCard(
            item: item,
            list: list,
            sections: sections,
            onEdit: onEdit,
            onDelete: onDelete,
            onMove: action,
            onCheck: onCheck
        )
    }
}

#Preview {
    ItemCard(
        item: ListItemModel(
            id: UUID(),
            name: "Item",
            isCheck: true
        ),
        list: ListModel(
            id: UUID(),
            name: "scroll",
            color: "red"
        ),
        sections: [SectionModel<ListItemModel>(
            name: "Section A",
            items: []
        )]
    )
}
