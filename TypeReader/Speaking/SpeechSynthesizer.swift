import AVFoundation
import Foundation
import MediaPlayer

protocol SpeechSynthesizerDelegate: AnyObject {
    func speechSynthesizer(_: SpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, sentence: String, in: String)
    func speechSynthesizer(_: SpeechSynthesizer, didFinishSpeaking text: String)
    func speechSynthesizerDidSkipForward(_: SpeechSynthesizer)
    func speechSynthesizerDidSkipBack(_: SpeechSynthesizer)
    func speechSynthesizerDidPlay(_: SpeechSynthesizer)
    func speechSynthesizerDidPause(_: SpeechSynthesizer)
}

protocol UserSettings {
    func string(forKey defaultName: String) -> String?
    func float(forKey defaultName: String) -> Float
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Float, forKey defaultName: String)
}

extension UserDefaults: UserSettings {}

class SpeechSynthesizer: NSObject {
    static let shared = SpeechSynthesizer()
    private let speechSynthesizer = AVSpeechSynthesizer()
    var currentUtterance: AVSpeechUtterance?
    public weak var delegate: SpeechSynthesizerDelegate?
    private let userSettings: UserSettings

    init(userDefaults: UserSettings = UserDefaults.standard) {
        userSettings = userDefaults

        super.init()
        speechSynthesizer.delegate = self

        setupAudioSession()
        configureRemoteTransportControls()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio Session setup failed: \(error)")
        }
    }

    private func configureRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] _ in
            if play() {
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if pause() {
                return .success
            }
            return .commandFailed
        }

        commandCenter.previousTrackCommand.addTarget { _ in
            self.delegate?.speechSynthesizerDidSkipBack(self)
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { _ in
            self.delegate?.speechSynthesizerDidSkipForward(self)
            return .success
        }
    }

    func speakText(_ text: String, title: String, subtitle: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)

        if let identifier = userSettings.string(forKey: "selectedVoiceIdentifier"),
           let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.identifier == identifier })
        {
            utterance.voice = voice
        } else {
            let lang = AVSpeechSynthesisVoice.currentLanguageCode().components(separatedBy: "-").first ?? "en"
            let voices = AVSpeechSynthesisVoice.speechVoices().filter {
                $0.language == lang
            }
            let defaultVoice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == AVSpeechSynthesisVoice.currentLanguageCode() })
            utterance.voice = voices.first ?? defaultVoice
        }
        utterance.rate = userSettings.float(forKey: "speechRate")
        if utterance.rate == 0 {
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        }
        speechSynthesizer.speak(utterance)
        currentUtterance = utterance
        updateNowPlayingInfo(title: title, subtitle: subtitle)
    }
    
    @discardableResult
    func play() -> Bool {
        if self.speechSynthesizer.isSpeaking {
            self.speechSynthesizer.continueSpeaking()
            return true
        }
        return false
    }

    @discardableResult
    func pause() -> Bool {
        if self.speechSynthesizer.isSpeaking {
            self.speechSynthesizer.pauseSpeaking(at: .immediate)
            return true
        }
        return false
    }
    
    private func updateNowPlayingInfo(title: String, subtitle: String) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = subtitle
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    // MARK: - AVSpeechSynthesizerDelegate methods

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speechSynthesizer(self, didFinishSpeaking: utterance.speechString)
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didPause _: AVSpeechUtterance) {}

    func speechSynthesizer(_: AVSpeechSynthesizer, didContinue _: AVSpeechUtterance) {}

    func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let currentSentence = utterance.speechString.sentence(containing: characterRange)
        delegate?.speechSynthesizer(self, willSpeakRangeOfSpeechString: characterRange, sentence: currentSentence, in: utterance.speechString)
    }
}
