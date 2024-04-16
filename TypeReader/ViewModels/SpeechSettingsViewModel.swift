import Foundation
import AVFoundation

class SpeechSettingsViewModel: ObservableObject {
    private let userSettings: UserSettings
    
    @Published var selectedVoiceIdentifier: String {
        didSet {
            userSettings.set(selectedVoiceIdentifier, forKey: "selectedVoiceIdentifier")
        }
    }
    
    @Published var speechRate: Float {
        didSet {
            userSettings.set(speechRate, forKey: "speechRate")
        }
    }
    
    var voices: [AVSpeechSynthesisVoice] = []
    
    init(userDefaults: UserSettings = UserDefaults.standard) {
        self.userSettings = userDefaults
        // Load saved settings or defaults
        self.selectedVoiceIdentifier = userSettings.string(forKey: "selectedVoiceIdentifier") ?? AVSpeechSynthesisVoice.currentLanguageCode()
        self.speechRate = userSettings.float(forKey: "speechRate")
        if self.speechRate == 0 {
            self.speechRate = AVSpeechUtteranceDefaultSpeechRate
        }
        
        // Fetch available voices
        self.voices = AVSpeechSynthesisVoice.speechVoices()
    }
}
