@testable import TypeReader
import XCTest
import Nimble

final class SpeechSettingsViewModelTests: XCTestCase {
    func test_SettingsViewModel_whenSettings_shouldSetRate() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 1.5
        mockUserSettings.stringForKeyReturnValue = "com.apple.speech.synthesis.voice.Princess"
        
        let sut = SpeechSettingsViewModel(userDefaults: mockUserSettings)
        
        expect(sut.speechRate) == 1.5
        expect(sut.selectedVoiceIdentifier) == "com.apple.speech.synthesis.voice.Princess"
    }
    
    func test_SettingsViewModel_whenNoSettings_shouldSetRate() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 0
        
        let sut = SpeechSettingsViewModel(userDefaults: mockUserSettings)
        
        expect(sut.speechRate) == 0.5
    }
    
    func test_SettingsViewModel_whenSetID_shouldSaveID() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 0
        
        let sut = SpeechSettingsViewModel(userDefaults: mockUserSettings)
        sut.selectedVoiceIdentifier = "com.apple.speech.synthesis.voice.Princess"
        sut.speechRate = 0.6
        
        let identifier = try XCTUnwrap(mockUserSettings.setForKeyReceivedArguments?.value as? String)
        expect(identifier) == "com.apple.speech.synthesis.voice.Princess"
        expect(mockUserSettings.setFloatForKeyReceivedArguments?.value) == 0.6
    }
}
