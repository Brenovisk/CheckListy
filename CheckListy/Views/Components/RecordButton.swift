//
//  RecordButton.swift
//  CheckListy
//
//  Created by Breno Lucas on 21/07/24.
//

import Foundation
import SwiftUI
import AudioToolbox

struct RecordButton: View {
    
    @Binding var transcript: String
    @Binding var isPressed: Bool
    @State private var timer: Timer?
    @State private var showTranscript: Bool = false
    
    var color: Color = .primary
    var onStartRecord: (() -> Void)?
    var onEndRecord: (() -> Void)?
    
    private init(transcript: Binding<String>, isPressed: Binding<Bool>, color: Color = .primary, onStartRecord: (() -> Void)?, onEndRecord: (() -> Void)?) {
        self.init(transcript: transcript, isPressed: isPressed, color: color)
        self.onStartRecord = onStartRecord
        self.onEndRecord = onEndRecord
    }
    
    init(transcript: Binding<String>, isPressed: Binding<Bool>, color: Color = .primary) {
        self._transcript = transcript
        self._isPressed = isPressed
        self.color = color
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {}) {
                    Image(systemName: "mic")
                        .resizable()
                        .frame(width: 18, height: 24)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Circle().fill(Color.red))
                        .scaleEffect(isPressed ? 1.1 : 1.0) // Pulsating effect
                        .animation(
                            isPressed ? Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default,
                            value: isPressed
                        )
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: .zero)
                        .onChanged { _ in
                           startRecording()
                        }
                        .onEnded { _ in
                            stopRecording()
                        }
                )
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)
            
            if (isPressed || !transcript.isEmpty) && showTranscript {
                VStack {
                    HStack {
                        if isPressed {
                            AudioAnimation(color: color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        } else {
                            if !isPressed {
                                Text(transcript)
                                    .font(.body)
                                    .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .tertiarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                }
                .frame(height: 220, alignment: .top)
            }
        }
    }
    
}

// MARK: - Helper methods
extension RecordButton {
    
    private func startRecording() {
        onStartRecord?()
        self.showTranscript = true
        resetTimer()
        FeedbackService.shared.provideHapticFeedback()
    }
    
    private func stopRecording() {
        onEndRecord?()
        FeedbackService.shared.provideHapticFeedback()
    }
    
    private func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            withAnimation {
                self.showTranscript = false
            }
        }
    }
    
    private func resetTimer() {
        setupTimer()
    }
    
}

// MARK: - Callbacks modifiers
extension RecordButton {
    
    func `onStartRecord`(action: (() -> Void)?) -> RecordButton {
        RecordButton(
            transcript: self.$transcript,
            isPressed: self.$isPressed,
            color: self.color,
            onStartRecord: action,
            onEndRecord: self.onEndRecord
        )
    }
    
    func `onEndRecord`(action: (() -> Void)?) -> RecordButton {
        RecordButton(
            transcript: self.$transcript,
            isPressed: self.$isPressed,
            color: self.color,
            onStartRecord: self.onStartRecord,
            onEndRecord: action
        )
    }
    
}

#Preview {
    RecordButton(transcript: Binding.constant("Teste"), isPressed: Binding.constant(false))
}
