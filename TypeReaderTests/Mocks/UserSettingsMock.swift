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
    
   // MARK: - set

    var setForKeyCallsCount = 0
    var setForKeyCalled: Bool {
        setForKeyCallsCount > 0
    }
    var setForKeyReceivedArguments: (value: Any?, defaultName: String)?
    var setForKeyReceivedInvocations: [(value: Any?, defaultName: String)] = []
    var setForKeyClosure: ((Any?, String) -> Void)?

    func set(_ value: Any?, forKey defaultName: String) {
        setForKeyCallsCount += 1
        setForKeyReceivedArguments = (value: value, defaultName: defaultName)
        setForKeyReceivedInvocations.append((value: value, defaultName: defaultName))
        setForKeyClosure?(value, defaultName)
    }
    
   // MARK: - set

    var setFloatForKeyCallsCount = 0
    var setFloatForKeyCalled: Bool {
        setFloatForKeyCallsCount > 0
    }
    var setFloatForKeyReceivedArguments: (value: Float, defaultName: String)?
    var setFloatForKeyReceivedInvocations: [(value: Float, defaultName: String)] = []
    var setFloatForKeyClosure: ((Float, String) -> Void)?

    func set(_ value: Float, forKey defaultName: String) {
        setFloatForKeyCallsCount += 1
        setFloatForKeyReceivedArguments = (value: value, defaultName: defaultName)
        setFloatForKeyReceivedInvocations.append((value: value, defaultName: defaultName))
        setFloatForKeyClosure?(value, defaultName)
    }
}
