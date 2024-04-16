import Foundation
@testable import TypeReader

// MARK: - UserSettingsMock -

final class UserSettingsMock: UserSettings {
    
   // MARK: - string

    var stringForKeyCallsCount = 0
    var stringForKeyCalled: Bool {
        stringForKeyCallsCount > 0
    }
    var stringForKeyReceivedDefaultName: String?
    var stringForKeyReceivedInvocations: [String] = []
    var stringForKeyReturnValue: String?
    var stringForKeyClosure: ((String) -> String?)?

    func string(forKey defaultName: String) -> String? {
        stringForKeyCallsCount += 1
        stringForKeyReceivedDefaultName = defaultName
        stringForKeyReceivedInvocations.append(defaultName)
        return stringForKeyClosure.map({ $0(defaultName) }) ?? stringForKeyReturnValue
    }
    
   // MARK: - float

    var floatForKeyCallsCount = 0
    var floatForKeyCalled: Bool {
        floatForKeyCallsCount > 0
    }
    var floatForKeyReceivedDefaultName: String?
    var floatForKeyReceivedInvocations: [String] = []
    var floatForKeyReturnValue: Float!
    var floatForKeyClosure: ((String) -> Float)?

    func float(forKey defaultName: String) -> Float {
        floatForKeyCallsCount += 1
        floatForKeyReceivedDefaultName = defaultName
        floatForKeyReceivedInvocations.append(defaultName)
        return floatForKeyClosure.map({ $0(defaultName) }) ?? floatForKeyReturnValue
    }
}
