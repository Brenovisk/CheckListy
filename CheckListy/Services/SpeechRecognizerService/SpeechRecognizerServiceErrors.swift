//
//  SpeechRecognizerServiceErrors.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation

enum SpeechRecognizerServiceErrors: Error, LocalizedError {
    
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable
    
}

extension SpeechRecognizerServiceErrors: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .nilRecognizer: 
            return "Can't initialize speech recognizer"
        case .notAuthorizedToRecognize:
            return "Not authorized to recognize speech"
        case .notPermittedToRecord:
            return "Not permitted to record audio"
        case .recognizerIsUnavailable:
            return "Recognizer is unavailable"
        }
    }
    
}
