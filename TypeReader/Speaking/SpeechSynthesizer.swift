import AVFoundation
import Foundation
import MediaPlayer

protocol SpeechSynthesizerDelegate: AnyObject {
    func speechSynthesizer(_: SpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, in: String)
}

class SpeechSynthesizer: NSObject {
    static let shared = SpeechSynthesizer()
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    public weak var delegate: SpeechSynthesizerDelegate?

    override init() {
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
            if self.speechSynthesizer.isSpeaking {
                self.speechSynthesizer.continueSpeaking()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.speechSynthesizer.isSpeaking {
                self.speechSynthesizer.pauseSpeaking(at: .immediate)
                return .success
            }
            return .commandFailed
        }

        commandCenter.skipBackwardCommand.addTarget { _ in
            .commandFailed
        }

        commandCenter.skipForwardCommand.addTarget { _ in
            .commandFailed
        }
    }

    func speakText(_ text: String, language _: String = "en-UK", rate: Float = 0.5) {
        speechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        let lang = AVSpeechSynthesisVoice.currentLanguageCode().components(separatedBy: "-").first ?? "en"

        let voices = AVSpeechSynthesisVoice.speechVoices().filter { ($0.quality == .premium || $0.quality == .enhanced)
            && $0.language.hasPrefix(lang)
        }
        let defaultVoice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == AVSpeechSynthesisVoice.currentLanguageCode() })
        utterance.voice = voices.first ?? defaultVoice
        utterance.rate = rate
        DispatchQueue.global().async {
            self.speechSynthesizer.speak(utterance)
        }
        currentUtterance = utterance
        updateNowPlayingInfo(title: "Speech Synthesis")
    }

    private func updateNowPlayingInfo(title: String) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    // MARK: - AVSpeechSynthesizerDelegate methods

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) { }

    func speechSynthesizer(_: AVSpeechSynthesizer, didPause _: AVSpeechUtterance) { }
    
    func speechSynthesizer(_: AVSpeechSynthesizer, didContinue _: AVSpeechUtterance) { }

    func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        self.delegate?.speechSynthesizer(self, willSpeakRangeOfSpeechString: characterRange, in: utterance.speechString)
    }
}
