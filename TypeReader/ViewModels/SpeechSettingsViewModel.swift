import Foundation
import AVFoundation

class SpeechSettingsViewModel: ObservableObject {
    @Published var selectedVoiceIdentifier: String
    
    @Published var speechRate: Float
    
    var voices: [AVSpeechSynthesisVoice] = []
    
    init(settings: AppSettings = UserDefaultsSettings()) {
        selectedVoiceIdentifier = settings.selectedVoiceIdentifier
        speechRate = settings.speechRate
        voices = AVSpeechSynthesisVoice.speechVoices()
    }
}
