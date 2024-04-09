import Foundation
import AVFoundation

class SpeechSettingsViewModel: ObservableObject {
    @Published var selectedVoiceIdentifier: String {
        didSet {
            UserDefaults.standard.set(selectedVoiceIdentifier, forKey: "selectedVoiceIdentifier")
        }
    }
    
    @Published var speechRate: Float {
        didSet {
            UserDefaults.standard.set(speechRate, forKey: "speechRate")
        }
    }
    
    var voices: [AVSpeechSynthesisVoice] = []
    
    init() {
        // Load saved settings or defaults
        self.selectedVoiceIdentifier = UserDefaults.standard.string(forKey: "selectedVoiceIdentifier") ?? AVSpeechSynthesisVoice.currentLanguageCode()
        self.speechRate = UserDefaults.standard.float(forKey: "speechRate")
        if self.speechRate == 0 {
            self.speechRate = AVSpeechUtteranceDefaultSpeechRate
        }
        
        // Fetch available voices
        self.voices = AVSpeechSynthesisVoice.speechVoices()
    }
}
