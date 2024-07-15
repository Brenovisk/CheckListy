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
    
    @State private var isPressed = false
    @State private var isShowForm = false
    @State private var multiSelection = Set<UUID>()
    @State private var showTitle = false
    
    @EnvironmentObject var viewModel: DetailsListViewModel
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack(){
                    VStack {
                        if let list = viewModel.detailsList {
                            TitleIcon(title: list.name, icon: list.icon, color: Color(list.color))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                        }
                        
                        List(viewModel.items) { item in
                            VStack {
                                Button(action: {
                                    withAnimation {
                                        viewModel.set(isCheck: !item.isCheck, of: item)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: item.isCheck ? "circle.fill" : "circle")
                                            .foregroundColor(.blue)
                                        Text(item.name)
                                    }                    }
                            }
                        }
                    }

                }
                .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scroll")).minY)
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ViewOffsetKey.self) { value in
            handleScrollValue(value)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                if showTitle, let list = viewModel.detailsList {
                    TitleIcon(title: list.name, icon: list.icon, color: Color(list.color), iconSize: 10)
                }
            }
            
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { isShowForm.toggle() }) {
                    Image(systemName: "gear")
                        .foregroundColor(Color.accentColor)
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
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
            FormListView(item: $viewModel.detailsList)
                .onSave() { newList in
                    viewModel.updateList(with: newList)
                }
                .onClose() {
                    isShowForm.toggle()
                }
        }
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
        withAnimation {
            showTitle =  value < (-30)
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
                        items: []
                    )
                )
            )
    }
}


struct CustomTitleView: View {
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("Título Customizado")
                .font(.headline) // Usar .headline em vez de .largeTitle para melhor ajuste na barra de navegação
                .fontWeight(.bold)
        }
    }
}
