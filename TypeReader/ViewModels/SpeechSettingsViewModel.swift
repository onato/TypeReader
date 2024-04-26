import Foundation
import AVFoundation

extension NSNotification.Name {
    static let didChangeRate = Notification.Name("com.onato.typereader.didChangeRate")
    static let didChangeVoice = Notification.Name("com.onato.typereader.didChangeVoice")
}

protocol Notifier {
    func post(name: Notification.Name)
}
extension NotificationCenter: Notifier {
    func post(name: Notification.Name) {
        post(name: name, object: nil)
    }
}

class SpeechSettingsViewModel: ObservableObject {
    @Published var selectedVoiceIdentifier: String {
        didSet {
            settings.selectedVoiceIdentifier = selectedVoiceIdentifier
            notifier.post(name: .didChangeVoice)
        }
    }

    @Published var speechRate: Float {
        didSet {
            settings.speechRate = speechRate
        }
    }
    
    var voices: [AVSpeechSynthesisVoice] = []
    let notifier: Notifier
    var settings: AppSettings
    
    init(settings: AppSettings = UserDefaultsSettings(), notifier: Notifier = NotificationCenter.default) {
        selectedVoiceIdentifier = settings.selectedVoiceIdentifier ?? ""
        speechRate = settings.speechRate
        voices = AVSpeechSynthesisVoice.speechVoices()
        self.notifier = notifier
        self.settings = settings
    }
    
    func releasedSlider() {
        notifier.post(name: .didChangeRate)
    }
}
