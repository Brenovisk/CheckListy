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
    @State var selectedSegmentIndex = 0
    @State var scrollOffset: CGFloat = 0

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            VStack {
                VStack(spacing: .zero) {
                    WelcomeView(
                        userName: viewModel.userName ?? String(),
                        uiImage: viewModel.userImage,
                        numberOfList: viewModel.lists.isEmpty ? nil : viewModel.incompleteLists.count
                    )
                    .task {
                        viewModel.getUserName()
                        await viewModel.getUserImage()
                    }
                    .onTapGesture {
                        NavigationService.shared.navigateTo(.profileView)
                    }
                    .padding(.vertical, 24)

                    HStack(alignment: .center) {
                        TitleIcon(title: "Minhas Listas")

                        Spacer()

                        actionButtons
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)

                if viewModel.showSearchBar {
                    AutoFocusTextField(text: $viewModel.searchText, placeholder: "Pesquisar...")
                        .roundedBackgroundTextField()
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }

                if viewModel.isLoading {
                    Skeleton(
                        hasRecents: !viewModel.recentsSection.items.isEmpty,
                        hasSegment: true
                    )
                } else {
                    if viewModel.showRecentSection {
                        Section(header: recentsHeaderSection) {
                            ForEach(viewModel.recents, id: \.self) { list in
                                card(list, visualization: Binding.constant(.grid))
                                    .containerRelativeHorizontal()
                            }
                            .scrollHorizontal(padding: 16)
                            .collapse(isCollapsed: viewModel.recentsSection.collapsed)
                        }
                        .padding(.bottom, viewModel.recentsSection.collapsed ? 0 : 16)
                    }

                    if !viewModel.showSearchBar {
                        SegmentPicker(
                            selectedIndex: $selectedSegmentIndex,
                            segments: segments
                        )
                        .padding(.bottom, 24)
                        .padding(.top, 8)

                        segments[selectedSegmentIndex].content
                    } else {
                        allLists
                    }
                }
            }
            .scrollable(padding: .zero, scrollOffset: $scrollOffset) {
                TitleIcon(
                    title: "Minhas Listas",
                    iconSize: 10,
                    subtitle: "\(viewModel.lists.count)"
                )
            }
            .gradientTopDynamic(color: Color.accentColor, height: 220, scrollOffset: $scrollOffset)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                bottomBar
            }
        }
        .sheet(isPresented: $showCreateListForm) {
            FormListView(item: $viewModel.listToEdit)
                .onSave { newList in
                    handleOnSave(list: newList)
                }
                .onClose {
                    showCreateListForm.toggle()
                }
                .onSaveByCode { code in
                    viewModel.addList(by: code)
                }
        }
        .sheet(isPresented: $showSheetShare) {
            ShareSheet(items: viewModel.contentToShare)
        }
        .onAppear {
            viewModel.recentsSection.items = viewModel.getRecentsListId()
        }.onChange(of: verticalSizeClass) {
            viewModel.setVisualizationMode(according: verticalSizeClass)
        }
    }

    var allLists: some View {
        VStack {
            ForEach(viewModel.allLists, id: \.self) { list in
                card(list, visualization: $viewModel.visualizationMode)
            }
            .grid(enable: $viewModel.visualizationMode)
            .padding(.horizontal, 16)
        }
    }

    var favoriteLists: some View {
        VStack {
            ForEach(viewModel.favorites, id: \.self) { list in
                card(list, visualization: $viewModel.visualizationMode)
            }
            .grid(enable: $viewModel.visualizationMode)
            .padding(.horizontal, 16)
        }
    }

    var completeLists: some View {
        VStack {
            ForEach(viewModel.completeLists, id: \.self) { list in
                card(list, visualization: $viewModel.visualizationMode)
            }
            .grid(enable: $viewModel.visualizationMode)
            .padding(.horizontal, 16)
        }
    }

    var incompleteLists: some View {
        VStack {
            ForEach(viewModel.incompleteLists, id: \.self) { list in
                card(list, visualization: $viewModel.visualizationMode)
            }
            .grid(enable: $viewModel.visualizationMode)
            .padding(.horizontal, 16)
        }
    }

    var actionButtons: some View {
        HStack(spacing: 24) {
            SearchButton(isEnable: $viewModel.showSearchBar)
                .onEnable {
                    viewModel.toggleSearchBar()
                }

            Button(action: { viewModel.toggleVisualization() }) {
                (viewModel.visualizationMode == .list ? IconsHelper.rectangleGrid1x2 : IconsHelper.squareGrid1x2).value
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }

    var recentsHeaderSection: some View {
        HeaderSection(
            section: viewModel.recentsSection,
            icon: IconsHelper.clock.rawValue,
            enableAdd: false
        ).onCollapse { _ in
            viewModel.toggleCollapseRecentSection()
        }
        .padding(.horizontal, 16)
    }

    var favoritesHeaderSection: some View {
        HeaderSection(
            section: viewModel.favoritesSection,
            icon: IconsHelper.star.rawValue,
            enableAdd: false
        ).onCollapse { _ in
            viewModel.toggleCollapseFavoritesSection()
        }
    }

    var bottomBar: some View {
        HStack {
            Button(action: {
                viewModel.listToEdit = nil
                showCreateListForm.toggle()
            }) {
                HStack {
                    IconsHelper.plus.value
                    Text("Adicionar Lista")
                }
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

}

// MARK: - Helper methods
extension ListsView {

    private var segments: [SegmentCustom] {
        [
            SegmentCustom(
                title: "Todas",
                icon: IconsHelper.listBullet.value,
                color: Color(.blueApp),
                number: viewModel.allLists.count
            ) {
                allLists
            },
            SegmentCustom(
                title: "Favoritos",
                icon: IconsHelper.star.value,
                color: Color(.yellowApp),
                number: viewModel.favorites.count
            ) {
                favoriteLists
            },
            SegmentCustom(
                title: "Incompletas",
                icon: IconsHelper.xmark.value,
                color: Color(.redApp),
                number: viewModel.incompleteLists.count
            ) {
                incompleteLists
            },
            SegmentCustom(
                title: "Completas",
                icon: IconsHelper.checkmark.value,
                color: .accentColor,
                number: viewModel.completeLists.count
            ) {
                completeLists
            }
        ]
    }

    private func card(_ list: ListModel, visualization: Binding<ListMode>? = nil) -> some View {
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

    private func handleOnSave(list: ListModel) {
        if viewModel.listToEdit != nil {
            viewModel.update(list: list)
            return
        }
        viewModel.create(list: list)
    }

    private func handleEdit(_ list: ListModel) {
        withAnimation {
            viewModel.listToEdit = list
            showCreateListForm = true
        }
    }

    private func handleDelete(_ list: ListModel) {
        withAnimation {
            viewModel.delete(list: list)
        }
    }

    private func handleRedirect(_ list: ListModel) {
        NavigationService.shared.navigateTo(.detailsListView(list: list))
    }

    private func handleOnFavorite(_ list: ListModel) {
        withAnimation {
            viewModel.toggleIsFavorite(to: list)
        }
    }

    private func handleOnShare(_ list: ListModel) {
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
