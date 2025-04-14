

import UIKit

class UserDefault : NSObject {
    
    static let shared = UserDefault()
    
    // MARK: - Singleton Instance
    private override init() {}
    let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let inOnboarding = "inOnboarding"
        static let isFullVersionPurchased = "isFullVersionPurchased"
        static let reomeAdsPurchased = "reomeAdsPurchased"
        static let isThemeDarkLightMode = "isThemeDarkLightMode"
    }
    
    // MARK: - Variables & Constants
        
    var isLoggedIn: Bool {
        get { return defaults.bool(forKey: Keys.isLoggedIn) }
        set { defaults.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    var isOnboarding: Bool {
        get { return defaults.bool(forKey: Keys.inOnboarding) }
        set { defaults.set(newValue, forKey: Keys.inOnboarding) }
    }
    
    var isFullVersionPurchased: Bool {
        get { return defaults.bool(forKey: Keys.isFullVersionPurchased) }
        set { defaults.set(newValue, forKey: Keys.isFullVersionPurchased) }
    }
    
    var isReomeAdsPurchased: Bool {
        get { return defaults.bool(forKey: Keys.reomeAdsPurchased) }
        set { defaults.set(newValue, forKey: Keys.reomeAdsPurchased) }
    }
    
    var isThemeDarkLightMode: Bool {
        get { return defaults.bool(forKey: Keys.isThemeDarkLightMode) }
        set { defaults.set(newValue, forKey: Keys.isThemeDarkLightMode) }
    }
    
    // MARK: - Category Purchase Methods
    
    
    
    // MARK: - Store Data
    func storeData(key: String , value: Any) ->Any {
        
        switch key {
            case Keys.isLoggedIn:
                return isLoggedIn
            case Keys.inOnboarding:
                return isOnboarding
            case Keys.isFullVersionPurchased:
                return isFullVersionPurchased
            case Keys.reomeAdsPurchased:
                return isReomeAdsPurchased
            case Keys.isThemeDarkLightMode:
                return isThemeDarkLightMode
            default:
                return value
        }
    }
    
}
