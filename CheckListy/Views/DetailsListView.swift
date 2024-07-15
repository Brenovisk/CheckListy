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
    
    @EnvironmentObject var viewModel: DetailsListViewModel
    
    var body: some View {
        VStack {
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
                }            }
            .navigationTitle(viewModel.detailsList?.name ?? String())
            .toolbar() {
                ToolbarItemGroup(placement: .primaryAction){
                    Button(action: { isShowForm.toggle() }) {
                        Image(systemName: "gear")
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
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
                        startScrum()
                    }
                    .onEnded() { _ in
                        endScrum()
                    }
            )
        }.sheet(isPresented: $isShowForm) {
            FormListView(item: $viewModel.detailsList)
                .onSave() { newList in
                    viewModel.updateList(with: newList)
                }
                .onClose() {
                    isShowForm.toggle()
                }
        }
    }
    
    private func startScrum() {
        if !isPressed {
            withAnimation {
                isPressed = true
                speechRecognizer.resetTranscript()
                speechRecognizer.startTranscribing()
            }
        }
    }
    
    private func endScrum() {
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
        DetailsListView()
            .environmentObject(DetailsListViewModel(ListModel(name: String(), color: String(), icon: String(), items: [])))
    }
}
