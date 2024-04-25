@testable import TypeReader
import XCTest
import Nimble

final class SpeechSynthesizerTests: XCTestCase {
    func test_SpeechSynthesizer_whenSettingsSet_shouldSetupUtterance() throws {
        let settings = AppSettingsMock()
        settings.selectedVoiceIdentifier = "com.apple.speech.synthesis.voice.Princess"
        settings.speechRate = 1.7
        let sut = SpeechSynthesizer(settings: settings)
        
        sut.speakText("Hello", title: "Filename", subtitle: "12/123")
        
        expect(sut.currentUtterance?.voice?.identifier) == "com.apple.speech.synthesis.voice.Princess"
        expect(sut.currentUtterance?.rate) == 1.7
    }
    
    func test_SpeechSynthesizer_whenSettingsNotSet_shouldSetupUtterance() throws {
        let settings = AppSettingsMock()
        settings.speechRate = 0
        let sut = SpeechSynthesizer(settings: settings)
        
        sut.speakText("Hello", title: "Filename", subtitle: "12/123")
        
        expect(sut.currentUtterance?.voice?.identifier) != nil
        expect(sut.currentUtterance?.rate) == 0.5
    }
}
