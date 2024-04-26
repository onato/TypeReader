import Foundation
import AVFoundation

protocol AppSettings {
    var selectedVoiceIdentifier: String? { get set }
    var speechRate: Float { get set }
}

protocol UserSettings {
    func string(forKey defaultName: String) -> String?
    func float(forKey defaultName: String) -> Float
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ value: Float, forKey defaultName: String)
}

extension UserDefaults: UserSettings {}

class UserDefaultsSettings: AppSettings {
    private let userSettings: UserSettings
    
    var selectedVoiceIdentifier: String? {
        get {
            userSettings.string(forKey: "selectedVoiceIdentifier")
        }
        set {
            userSettings.set(newValue, forKey: "selectedVoiceIdentifier")
        }
    }
    var speechRate: Float {
        get {
            userSettings.float(forKey: "speechRate")
        }
        set {
            userSettings.set(newValue, forKey: "speechRate")
        }
    }
    init(userDefaults: UserSettings = UserDefaults.standard) {
        self.userSettings = userDefaults
    }
}
