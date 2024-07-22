//
//  DetailsList.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI
import FirebaseDatabase

struct DetailsListView: View {
    
    @StateObject var speechRecognizer = SpeechRecognizerService()
    @EnvironmentObject var viewModel: DetailsListViewModel
    
    @State private var isPressed = false
    @State private var isShowForm = false
    @State private var isShowFormItem = false
    @State private var multiSelection = Set<UUID>()
    @State private var showTitle = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack {
                TitleIcon(title: viewModel.list.name, icon: viewModel.list.icon, color: Color(viewModel.list.color))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 24)
                
                ForEach(viewModel.sections) { sectionList in
                    Section(header: headerSection(sectionList)) {
                        VStack {
                            ForEach(sectionList.items) { item in
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
                                    .onMove { item, section in
                                        viewModel.move(item, to: section)
                                    }
                            }
                        }
                        .padding(.bottom, 16)
                        .collapse(isCollapsed: sectionList.name.isEmpty ? false : sectionList.collapsed)
                    }
                    
                }
            }
            
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scroll")).minY)
            }
        }
        .coordinateSpace(name: "scroll")
        .padding(.horizontal, 16)
        .onPreferenceChange(ViewOffsetKey.self) { value in
            handleScrollValue(value)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if showTitle {
                    TitleIcon(title: viewModel.list.name, icon: viewModel.list.icon, color: Color(viewModel.list.color), iconSize: 10)
                }
            }
            
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { isShowForm.toggle() }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.accentColor)
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
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
                
                VStack {
                    if !isPressed {
                        Text(speechRecognizer.transcript)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "mic")
                            .resizable()
                            .frame(width: 18, height: 24)
                    }
                    .symbolEffect(.bounce, value: 1)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: .zero)
                            .onChanged() { _ in
                                startRecord()
                            }
                            .onEnded() { _ in
                                endRecord()
                            }
                    )
                }
            }
        }
        .sheet(isPresented: $isShowForm) {
            FormListView(item: listOptionalBinding)
                .onSave() { newList in
                    viewModel.updateList(with: newList)
                }
                .onClose() {
                    isShowForm.toggle()
                }
        }
        .sheet(isPresented: $isShowFormItem) {
            FormItemView(
                item: $viewModel.itemToEdit,
                section: $viewModel.sectionSelected
            )
            .onSave() { item in
                if viewModel.itemToEdit != nil {
                    viewModel.update(item)
                    return
                }
                viewModel.add(item)
                viewModel.sectionSelected = String()
            }
            .onClose() {
                isShowFormItem = false
                viewModel.sectionSelected = String()
            }
        }
        
    }
    
    func headerSection(_ section: SectionModel) -> some View {
        HStack {
            if !section.name.isEmpty {
                Text(section.name.uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.lightGray))
                
                Spacer()
                
                HStack(spacing: 24){
                    Button(action: {
                        withAnimation {
                            viewModel.itemToEdit = nil
                            viewModel.sectionSelected = section.name
                            isShowFormItem = true
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: {
                        withAnimation {
                            viewModel.setCollapsed(of: section, with: !section.collapsed)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .rotationEffect(section.collapsed ? .zero : .degrees(90))
                    }
                }.padding(.bottom, 16)
            }
        }
        .frame(alignment: .center)
        .font(.headline)
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
    
    private func handleScrollValue(_ value: ViewOffsetKey.Value) {
        if offset == 0 {
            offset = value
        }
        
        withAnimation {
            showTitle =  value < (offset - 30)
        }
    }
    
}

#Preview {
    NavigationStack {
        DetailsListView()
            .environmentObject(
                DetailsListViewModel(
                    ListModel(
                        name: "List name" ,
                        color: "green",
                        icon: "checkmark",
                        items: [
                            ListItemModel(
                                name: "Teste",
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
                            ),
                        ]
                    )
                )
            )
    }
}
