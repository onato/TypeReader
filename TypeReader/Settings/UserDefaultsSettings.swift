import Foundation
import AVFoundation

protocol AppSettings {
    var selectedVoiceIdentifier: String { get set }
    var speechRate: Float { get set }
}

class UserDefaultsSettings: AppSettings {
    private let userSettings: UserSettings
    
    var selectedVoiceIdentifier: String {
        didSet {
            userSettings.set(selectedVoiceIdentifier, forKey: "selectedVoiceIdentifier")
        }
    }
    var speechRate: Float {
        didSet {
            userSettings.set(speechRate, forKey: "speechRate")
        }
    }
    init(userDefaults: UserSettings = UserDefaults.standard) {
        self.userSettings = userDefaults
        if let voiceIdentifier = userSettings.string(forKey: "selectedVoiceIdentifier") {
            selectedVoiceIdentifier = voiceIdentifier
        } else {
            selectedVoiceIdentifier = (AVSpeechSynthesisVoice.speechVoices().first { voice in
                voice.language == AVSpeechSynthesisVoice.currentLanguageCode()
            })?.identifier ?? "There are no voices installed"
        }
        self.speechRate = userSettings.float(forKey: "speechRate")
        if self.speechRate == 0 {
            self.speechRate = AVSpeechUtteranceDefaultSpeechRate
        }
    }
}
