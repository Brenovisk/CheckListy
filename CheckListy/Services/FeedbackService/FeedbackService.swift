//
//  FeedbackService.swift
//  CheckListy
//
//  Created by Breno Lucas on 22/07/24.
//

import AudioToolbox
import SwiftUI
import AVFAudio

class FeedbackService {
    
    static var shared = FeedbackService()
    private init() {}
    
    var audioPlayer: AVAudioPlayer?
    
    func provideHapticFeedback() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }

    func playSoundFeedback(soundID: Int) {
        DispatchQueue.main.async {
            AudioServicesPlaySystemSound(SystemSoundID(soundID))
        }
    }
    
    func playCheckSoundFeedback() {
        playSound(named: "check")
    }
    
}

extension FeedbackService {
    
    private func playSound(named soundName: String, withExtension ext: String = "mp3") {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}

