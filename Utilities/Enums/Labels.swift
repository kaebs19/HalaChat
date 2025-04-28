
import Foundation


enum Lables: String  {
    
    case findNew = "FindNewLab"
    case findNewSubtitle = "FindNewSubtitleLab"
    case login = "loginLabel"
    case signup = "registerLabel"
    case welcome = "welcomeLabel"
    case welcomeSubtitle = "welcomeSubtitleLabel"
    case createAccount = "createAccountLabel"
    
    var textLib: String {
        return self.rawValue.localized
    }

}

