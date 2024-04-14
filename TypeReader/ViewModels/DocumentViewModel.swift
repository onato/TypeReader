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
    var showingSettings = false
    var showDocumentPicker = false
    var textSpoken: String = ""
    var textBeingSpoken: String = ""
    var textToSpeak: String = ""

    private func speakText() {
        textSpoken = ""
        textBeingSpoken = ""
        textToSpeak = documentPages[currentPage]
        SpeechSynthesizer.shared.delegate = self
        SpeechSynthesizer.shared.speakText(documentPages[currentPage])
    }
}

extension DocumentViewModel: SpeechSynthesizerDelegate {
    func speechSynthesizer(_: SpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, in text: String) {
        let startIndex = text.index(text.startIndex, offsetBy: characterRange.location)
        let endIndex = text.index(startIndex, offsetBy: characterRange.length)
        let currentSubstring = text[startIndex ..< endIndex]
//        print(currentSubstring)
        textSpoken = String(text[..<startIndex])
        textBeingSpoken = String(currentSubstring)
        textToSpeak = String(text[endIndex..<text.endIndex])
    }
}
