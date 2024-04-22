import SwiftUI

@Observable class DocumentViewModel {
    var documentPages: [String] = [] {
        didSet {
            if currentPage < documentPages.count {
                speakText()
            }
        }
    }
    var currentPage = 0 {
        didSet {
            speakText()
        }
    }
    var isTracking = false {
        didSet {
            if isTracking {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isTracking = false
                }
            }
        }
    }
    var showingSettings = false
    var showDocumentPicker = false
    var currentSentence: String = ""
    var textSpoken: String = ""
    var textBeingSpoken: String = ""
    var textToSpeak: String = ""
    var fileName: String = ""
    var fileURL: URL!
    var subtitle: String {
        documentPages.isEmpty ? "" : "\(currentPage + 1)/\(documentPages.count)"
    }
    var dateLastTouched = Date()

    private func speakText() {
        SpeechSynthesizer.shared.delegate = self
        SpeechSynthesizer.shared.speakText(documentPages[currentPage], title: fileName, subtitle: subtitle)
        
        textSpoken = ""
        textBeingSpoken = ""
        textToSpeak = documentPages[currentPage]
    }
    public func didTouchScreen() {
        dateLastTouched = Date()
    }
}

extension DocumentViewModel: SpeechSynthesizerDelegate {
    func speechSynthesizerDidSkipForward(_: SpeechSynthesizer) {
        guard currentPage < documentPages.count - 1 else { return }
        currentPage += 1
    }
    
    func speechSynthesizerDidSkipBack(_: SpeechSynthesizer) {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }
    
    func speechSynthesizer(_: SpeechSynthesizer, didFinishSpeaking text: String) {
        if textToSpeak.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            currentPage += 1
        }
    }
    
    func speechSynthesizer(_: SpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, sentence: String, in text: String) {
        let startIndex = text.index(text.startIndex, offsetBy: characterRange.location)
        let endIndex = text.index(startIndex, offsetBy: characterRange.length)
        let currentSubstring = text[startIndex ..< endIndex]
        
        currentSentence = sentence
        textSpoken = String(text[..<startIndex])
        textBeingSpoken = String(currentSubstring)
        textToSpeak = String(text[endIndex..<text.endIndex])
    }
}
