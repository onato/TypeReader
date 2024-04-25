import Foundation
@testable import TypeReader

// MARK: - AppSettingsMock -

final class AppSettingsMock: AppSettings {
    
   // MARK: - selectedVoiceIdentifier

    var selectedVoiceIdentifier: String? {
        get { underlyingSelectedVoiceIdentifier }
        set(value) { underlyingSelectedVoiceIdentifier = value }
    }
    internal var underlyingSelectedVoiceIdentifier: String!
    
   // MARK: - speechRate

    var speechRate: Float {
        get { underlyingSpeechRate }
        set(value) { underlyingSpeechRate = value }
    }
    internal var underlyingSpeechRate: Float!
}
