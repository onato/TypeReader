@testable import TypeReader
import XCTest
import Nimble

final class SpeechSettingsViewModelTests: XCTestCase {
    func test_SettingsViewModel_whenSettings_shouldSetRate() throws {
        let mockSettings = AppSettingsMock()
        mockSettings.speechRate = 1.5
        mockSettings.selectedVoiceIdentifier = "com.apple.speech.synthesis.voice.Princess"
        
        let sut = SpeechSettingsViewModel(settings: mockSettings)

        expect(sut.speechRate) == 1.5
        expect(sut.selectedVoiceIdentifier) == "com.apple.speech.synthesis.voice.Princess"
    }
}
