@testable import TypeReader
import XCTest
import Nimble
import AVFoundation

final class SpeechSettingsViewModelTests: XCTestCase {
    let voices = [
        AVSpeechSynthesisVoice(language: "en-US")!,
        AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.Trinoids")!,
        AVSpeechSynthesisVoice(language: "es-ES")!,
        AVSpeechSynthesisVoice(language: "es-MX")!,
        AVSpeechSynthesisVoice(language: "fr-CA")!,
        AVSpeechSynthesisVoice(language: "fr-FR")!
    ]
    
    func test_SettingsViewModel_whenSettings_shouldSetRate() throws {
        let mockSettings = AppSettingsMock()
        mockSettings.speechRate = 1.5
        mockSettings.selectedVoiceIdentifier = "com.apple.speech.synthesis.voice.Princess"
        
        let sut = SpeechSettingsViewModel(settings: mockSettings)

        expect(sut.speechRate) == 1.5
        expect(sut.selectedVoiceIdentifier) == "com.apple.speech.synthesis.voice.Princess"
    }
    
    func test_SettingsViewModel_whenWantingEnglish_shouldFilterOtherLanguages() throws {
        let sut = VoiceFetcher()
        let result = sut.fetch(voices: voices, preferredLanguages: ["en-NZ"])
        
        let english = try XCTUnwrap(result.first)
        expect(english.language) == "en-US"
    }
    
    func test_SettingsViewModel_whenFetchingShoudBeGrouped() {
        let sut = VoiceFetcher()
        
        let result = sut.groupedVoices(voices: voices)
        
        expect(result.map(\.name).sorted()) == ["English (United States)", "French (Canada)", "French (France)", "Spanish (Mexico)", "Spanish (Spain)"]
        expect(result[0].regions.count) == 2
        expect(result[1].regions.count) == 1
        expect(result[2].regions.count) == 1
    }
}
