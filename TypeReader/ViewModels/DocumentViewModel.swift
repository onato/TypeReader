import Foundation

@Observable
class DocumentViewModel {
    var documentPages: [String] = [] {
        didSet {
            if currentPage < documentPages.count {
                SpeechSynthesizer.shared.speakText(documentPages[currentPage])
            }
        }
    }
    var currentPage = 0 {
        didSet {
            SpeechSynthesizer.shared.speakText(documentPages[currentPage])
        }
    }
    var showingSettings = false
    var showDocumentPicker = false

    init() {}
}
