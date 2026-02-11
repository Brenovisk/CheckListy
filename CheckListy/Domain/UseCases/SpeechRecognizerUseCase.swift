//
//  SpeechRecognizerUseCase.swift
//  CheckListy
//

import Foundation
import Combine

class SpeechRecognizerUseCase {
    private let service: SpeechRecognizerService
    
    init(service: SpeechRecognizerService = SpeechRecognizerService()) {
        self.service = service
    }
    
    @MainActor
    var transcript: AnyPublisher<String, Never> {
        service.$transcript.eraseToAnyPublisher()
    }
    
    @MainActor
    func start() {
        service.startTranscribing()
    }
    
    @MainActor
    func stop() {
        service.stopTranscribing()
    }
    
    @MainActor
    func reset() {
        service.resetTranscript()
    }
}
