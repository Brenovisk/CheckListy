//
//  ListItemsView.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import SwiftUI

struct ListItemsView: View {
    
    @State private var isPressed = false
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var multiSelection = Set<UUID>()
    
    @EnvironmentObject var viewModel: ListItemViewModel
    
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
            .navigationTitle("Itens")
            
            if !isPressed {
                Text(speechRecognizer.transcript)
            }
            
            Button(action: {}) {
                Image(systemName: "mic")
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
    NavigationView {
        ListItemsView()
            .environmentObject(ListItemViewModel())
    }
}
