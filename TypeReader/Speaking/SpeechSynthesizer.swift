import AVFoundation
import Foundation
import MediaPlayer

class SpeechSynthesizer: NSObject {
    static let shared = SpeechSynthesizer()
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?

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
        speechSynthesizer.stopSpeaking(at: .word)
        let utterance = AVSpeechUtterance(string: text)
        let lang = Locale.current.language.languageCode?.identifier ?? "en"

        let voices = AVSpeechSynthesisVoice.speechVoices().filter { ($0.quality == .premium || $0.quality == .enhanced)
            && $0.language.hasPrefix("en")
        }
        utterance.voice = voices[0]
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

    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        print("Handle completion of speech")
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didPause _: AVSpeechUtterance) {
        print("Update UI or state as needed")
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, didContinue _: AVSpeechUtterance) {
        print("Update UI or state as needed")
    }

    func speechSynthesizer(_: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let startIndex = utterance.speechString.index(utterance.speechString.startIndex, offsetBy: characterRange.location)
        let endIndex = utterance.speechString.index(startIndex, offsetBy: characterRange.length)
        let currentSubstring = utterance.speechString[startIndex ..< endIndex]
        print(currentSubstring)
    }
}
