import AVFoundation
import Foundation

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

class VoiceLaunguage: Identifiable {
    var id: String
    var name: String { id }
    var regions: [AVSpeechSynthesisVoice]
    init(name: String, regions: [AVSpeechSynthesisVoice] = []) {
        id = name
        self.regions = regions
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

    let defaultVoices: [AVSpeechSynthesisVoice]
    let voices: [VoiceLaunguage]
    let topVoices: [AVSpeechSynthesisVoice]
    let notifier: Notifier
    var settings: AppSettings

    init(settings: AppSettings = UserDefaultsSettings(), notifier: Notifier = NotificationCenter.default) {
        selectedVoiceIdentifier = settings.selectedVoiceIdentifier ?? ""
        speechRate = settings.speechRate

        let allVoices = VoiceFetcher().fetch()
        defaultVoices = allVoices.filter { $0.quality == .default }
        topVoices = allVoices.filter { [.enhanced, .premium].contains($0.quality) }
        self.notifier = notifier
        self.settings = settings
        voices = VoiceFetcher().groupedVoices(voices: allVoices).sorted(by: {
            $0.name < $1.name
        })
    }

    func releasedSlider() {
        notifier.post(name: .didChangeRate)
    }

    func displayName(for languageCode: String) -> String {
        // Split the language code into language and region components
        let components = languageCode.split(separator: "-")
        guard components.count == 2 else {
            return Locale.current.localizedString(forLanguageCode: languageCode) ?? languageCode
        }

        let language = String(components[0])
        let region = String(components[1])

        // Get the localized names for language and region
        let languageName = Locale.current.localizedString(forLanguageCode: language) ?? language
        let regionName = Locale.current.localizedString(forRegionCode: region) ?? region

        // Combine the names
        return "\(regionName) \(languageName)"
    }
}

struct VoiceFetcher {
    func fetch(
        voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices(),
        preferredLanguages: [String] = Locale.preferredLanguages
    ) -> [AVSpeechSynthesisVoice] {
        let languages = preferredLanguages.map { $0.prefix(2) }
        return voices
            .filter {
                languages.contains($0.language.prefix(2))
            }.sorted { voice1, voice2 -> Bool in
                if voice1.language == voice2.language {
                    return voice1.name < voice2.name
                } else {
                    return voice1.language < voice2.language
                }
            }
    }

    func groupedVoices(voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()) -> [VoiceLaunguage] {
        voices.reduce(into: []) {
            let languageName = Locale.current.localizedString(forLanguageCode: $1.language) ?? $1.language
            let region = $1.language.contains("-") ? String($1.language.split(separator: "-").last!) : ""
            let regionName = Locale.current.localizedString(forRegionCode: region) ?? ""
            let language = "\(languageName) (\(regionName))"
            let group = $0.first(where: { $0.name == language })
            if let group {
                group.regions.append($1)
            } else {
                $0.append(VoiceLaunguage(name: language, regions: [$1]))
            }
        }
    }
}
