@testable import TypeReader
import XCTest
import Nimble

final class UserDefaultsAppSettingsTests: XCTestCase {
    func test_SettingsViewModel_whenSettings_shouldSetDefaults() throws {
        let defaults = UserDefaults()
        let sut = UserDefaultsSettings(userDefaults: defaults)
        
        sut.speechRate = 1.5
        sut.selectedVoiceIdentifier = "com.apple.speech.synthesis.voice.Princess"
        
        expect(defaults.string(forKey: "selectedVoiceIdentifier")) == "com.apple.speech.synthesis.voice.Princess"
        expect(defaults.float(forKey: "speechRate")) == 1.5
    }
    
    func test_SettingsViewModel_whenNoDefaults_shouldSetRate() throws {
        let mockUserSettings = UserSettingsMock()
        mockUserSettings.floatForKeyReturnValue = 0
        
        let sut = UserDefaultsSettings(userDefaults: mockUserSettings)
        
        expect(sut.speechRate) == 0
        expect(sut.selectedVoiceIdentifier) == nil
    }
}
