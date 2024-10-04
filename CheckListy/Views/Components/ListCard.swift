//
//  ListCard.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import SwiftUI

struct ListCard: View {

    @Binding var mode: ListMode
    @Environment(\.colorScheme) var colorScheme

    var list: ListModel
    var onEdit: ((ListModel) -> Void)?
    var onDelete: ((ListModel) -> Void)?
    var onRedirect: ((ListModel) -> Void)?
    var onFavorite: ((ListModel) -> Void)?
    var onShare: ((ListModel) -> Void)?

    private init(list: ListModel, mode: Binding<ListMode>? = nil, onEdit: ((ListModel) -> Void)?, onDelete: ((ListModel) -> Void)?, onRedirect: ((ListModel) -> Void)?, onFavorite: ((ListModel) -> Void)?, onShare: ((ListModel) -> Void)?) {
        self.init(list: list, mode: mode)

        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onRedirect = onRedirect
        self.onFavorite = onFavorite
        self.onShare = onShare
    }

    init(list: ListModel, mode: Binding<ListMode>? = nil) {
        self.list = list
        _mode = mode ?? Binding.constant(.grid)
    }

    var subTitleColor: Color {
        colorScheme == .dark ? Color(.lightGray) : Color(.darkGray)
    }

    var titleColor: Color {
        colorScheme == .dark ? Color.white : Color.black
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
                    HStack {
                        icon
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .onTapGesture {
                        onRedirect?(list)
                    }

                    menu
                }

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        listName

                        createdDate
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        if list.progressCompleted > 0.0 {
                            progressBar
                        }

                        checkedItems
                    }
                    .padding(.trailing, 12)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .onTapGesture {
                    onRedirect?(list)
                }
            }
        }
        .padding([.leading, .vertical], 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var listCard: some View {
        HStack {
            HStack(alignment: .center, spacing: .zero) {
                icon
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 2) {
                    listName

                    HStack {
                        createdDate
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 6) {
                    checkedItems

                    if list.progressCompleted > 0.0 {
                        progressBar
                    }
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .onTapGesture {
                onRedirect?(list)
            }

            menu
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    var listName: some View {
        Text(list.name)
            .lineLimit(1)
            .font(.body)
            .foregroundColor(titleColor)
    }

    var createdDate: some View {
        HStack(spacing: 4) {
            IconsHelper.calendar.value
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundColor(subTitleColor)

            Text(list.createdDate)
                .lineLimit(1)
                .font(.subheadline)
                .foregroundColor(subTitleColor)
        }
    }

    var checkedItems: some View {
        Text(list.checkItems)
            .font(.body)
            .foregroundColor(Color(list.color))
            .fontWeight(.semibold)
    }

    var progressBar: some View {
        CircularProgressBar(
            progress: list.progressCompleted,
            color: Color(list.color),
            lineWidth: 1,
            size: 12
        )
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
            Button(role: .destructive, action: {
                self.onDelete?(list)
            }) {
                Label("Deletar", systemImage: "trash")
            }

            Button(action: {
                self.onFavorite?(list)
            }) {
                Label(list.isFavorite ? "Desfavoritar" : "Favoritar", systemImage: list.isFavorite ? "star.slash" : "star")
            }

            Button(action: {
                self.onEdit?(list)
            }) {
                Label("Editar", systemImage: "pencil")
            }

            Button(action: {
                self.onShare?(list)
            }) {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding()
                .font(.system(size: 16))
        }
    }
}

// MARK: - Callbacks modifiers

extension ListCard {
    func onEdit(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: list,
            mode: $mode,
            onEdit: action,
            onDelete: onDelete,
            onRedirect: onRedirect,
            onFavorite: onFavorite,
            onShare: onShare
        )
    }

    func onDelete(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: list,
            mode: $mode,
            onEdit: onEdit,
            onDelete: action,
            onRedirect: onRedirect,
            onFavorite: onFavorite,
            onShare: onShare
        )
    }

    func onRedirect(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: list,
            mode: $mode,
            onEdit: onEdit,
            onDelete: onDelete,
            onRedirect: action,
            onFavorite: onFavorite,
            onShare: onShare
        )
    }

    func onFavorite(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: list,
            mode: $mode,
            onEdit: onEdit,
            onDelete: onDelete,
            onRedirect: onRedirect,
            onFavorite: action,
            onShare: onShare
        )
    }

    func onShare(action: ((ListModel) -> Void)?) -> ListCard {
        ListCard(
            list: list,
            mode: $mode,
            onEdit: onEdit,
            onDelete: onDelete,
            onRedirect: onRedirect,
            onFavorite: onFavorite,
            onShare: action
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
