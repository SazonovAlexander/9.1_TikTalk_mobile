import Foundation

class UserDefaultsHelper {

    static let shared = UserDefaultsHelper()

    private let userDefaults = UserDefaults.standard

    private init() {}

    func setBool(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    func getBool(forKey key: String) -> Bool? {
        return userDefaults.bool(forKey: key)
    }

}
