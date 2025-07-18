//
//  DetailsListView.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import FirebaseDatabase
import SwiftUI

struct DetailsListView: View {

    @StateObject var speechRecognizer = SpeechRecognizerService()
    @StateObject var viewModel: DetailsListViewModel

    @State private var isPressed = false
    @State private var isShowForm = false
    @State private var isShowFormItem = false
    @State private var multiSelection = Set<UUID>()

    var body: some View {
        VStack {
            TitleIcon(
                title: viewModel.list.name,
                icon: viewModel.list.icon,
                color: Color(viewModel.list.color),
                subtitle: viewModel.getCheckedItemByList()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)

            if viewModel.showSearchBar {
                AutoFocusTextField(text: $viewModel.searchText, placeholder: "Pesquisar...")
                    .roundedBackgroundTextField()
                    .padding(.bottom, 24)

                ForEach(viewModel.getItems(), id: \.id) { item in
                    card(item)
                }
            }

            if !viewModel.showSearchBar {
                ForEach(viewModel.sections, id: \.id) { sectionList in
                    Section(header: headerSection(sectionList)) {
                        VStack {
                            ForEach(sectionList.items) { item in
                                card(item)
                                    .onMove { item, section in
                                        viewModel.move(item, to: section)
                                    }
                            }.grid(enable: Binding.constant(.list), columns: 2)
                        }
                        .padding(.bottom, 16)
                        .collapse(isCollapsed: sectionList.name.isEmpty ? false : sectionList.collapsed)
                    }
                }
            }
        }
        .scrollable {
            TitleIcon(
                title: viewModel.list.name,
                icon: viewModel.list.icon,
                color: Color(viewModel.list.color),
                iconSize: 10,
                subtitle: viewModel.getCheckedItemByList()
            )
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                SearchButton(isEnable: $viewModel.showSearchBar)
                    .onEnable {
                        viewModel.toggleSearchBar()
                    }
            }

            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { isShowForm.toggle() }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.accentColor)
                }
            }

            ToolbarItemGroup(placement: .bottomBar) {
                ZStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            viewModel.itemToEdit = nil
                            isShowFormItem.toggle()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Adicionar Item")
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)

                    RecordButton(
                        transcript: $speechRecognizer.transcript,
                        isPressed: $isPressed,
                        color: Color(viewModel.list.color)
                    )
                    .onStartRecord {
                        startRecord()
                    }
                    .onEndRecord {
                        endRecord()
                    }
                }
            }
        }
        .sheet(isPresented: $isShowForm) {
            FormListView(item: listOptionalBinding)
                .onSave { newList in
                    viewModel.updateList(with: newList)
                }
                .onClose {
                    isShowForm.toggle()
                }
        }
        .sheet(isPresented: $isShowFormItem) {
            FormItemView(
                item: $viewModel.itemToEdit,
                section: $viewModel.sectionSelected
            )
            .onSave { item in
                if viewModel.itemToEdit != nil {
                    viewModel.update(item)
                    return
                }
                viewModel.add(item)
            }
            .onClose {
                isShowFormItem = false
                viewModel.sectionSelected = String()
            }
        }
    }

    func card(_ item: ListItemModel) -> ItemCard {
        ItemCard(item: item, list: viewModel.list, sections: viewModel.sections)
            .onCheck { item in
                withAnimation {
                    viewModel.set(isCheck: !item.isCheck, of: item)
                }
            }
            .onEdit { item in
                withAnimation {
                    viewModel.itemToEdit = item
                    viewModel.sectionSelected = String()
                    isShowFormItem.toggle()
                }
            }
            .onDelete { item in
                viewModel.remove(item)
            }
    }

    func headerSection(_ sectionList: SectionModel<ListItemModel>) -> some View {
        HeaderSection<ListItemModel>(section: sectionList, subtitle: viewModel.getCheckedItemBy(section: sectionList))
            .onAdd { section in
                withAnimation {
                    viewModel.itemToEdit = nil
                    viewModel.sectionSelected = section.name
                    isShowFormItem = true
                }
            }
            .onCollapse { section in
                withAnimation {
                    viewModel.setCollapsed(of: section, with: !section.collapsed)
                }
            }
    }

    var listOptionalBinding: Binding<ListModel?> {
        Binding<ListModel?>(
            get: { viewModel.list },
            set: { newValue in
                if let newValue = newValue {
                    viewModel.list = newValue
                }
            }
        )
    }

    private func startRecord() {
        if !isPressed {
            withAnimation {
                isPressed = true
                speechRecognizer.resetTranscript()
                speechRecognizer.startTranscribing()
            }
        }
    }

    private func endRecord() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                isPressed = false
                speechRecognizer.stopTranscribing()
                viewModel.changeItemIfNeeded(according: speechRecognizer.transcript)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailsListView(viewModel: DetailsListViewModel(
            ListModel(
                name: "List name",
                color: "green",
                icon: "checkmark",
                items: [
                    ListItemModel(
                        name: "Teste ",
                        description: "asdf",
                        section: "B",
                        isCheck: true
                    ),
                    ListItemModel(
                        name: "Teste",
                        description: "",
                        section: "",
                        isCheck: true
                    ),
                    ListItemModel(
                        name: "Teste",
                        description: "",
                        section: "",
                        isCheck: true
                    ),
                    ListItemModel(
                        name: "Teste",
                        description: "",
                        section: "",
                        isCheck: true
                    ),
                    ListItemModel(
                        name: "Teste",
                        description: "",
                        section: "Ahhh",
                        isCheck: true
                    )
                ]
            )
        ))
    }
}
