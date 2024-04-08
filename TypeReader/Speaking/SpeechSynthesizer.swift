import Foundation
import AVFoundation

class SpeechSynthesizer {
    static var shared = SpeechSynthesizer()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    func speakText(_ text: String, language: String = "en-US", rate: Float = 0.5) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        speechSynthesizer.speak(utterance)
    }
}
