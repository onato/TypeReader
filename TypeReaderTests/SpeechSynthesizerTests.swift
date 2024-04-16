@testable import TypeReader
import XCTest
import Nimble

final class SpeechSynthesizerTests: XCTestCase {
    func test_SpeechSynthesizer_whenSettingsSet_shouldSetupUtterance() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 1.7
        mockUserSettings.stringForKeyReturnValue = "com.apple.speech.synthesis.voice.Princess"
        let sut = SpeechSynthesizer(userDefaults: mockUserSettings)
        
        sut.speakText("Hello", title: "Filename", subtitle: "12/123")
        
        expect(sut.currentUtterance?.voice?.identifier) == "com.apple.speech.synthesis.voice.Princess"
        expect(sut.currentUtterance?.rate) == 1.7
    }
    
    func test_SpeechSynthesizer_whenSettingsNotSet_shouldSetupUtterance() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 0
        let sut = SpeechSynthesizer(userDefaults: mockUserSettings)
        
        sut.speakText("Hello", title: "Filename", subtitle: "12/123")
        
        expect(sut.currentUtterance?.voice?.identifier) != nil
        expect(sut.currentUtterance?.rate) == 0.5
    }
}
