
import Foundation


enum Lables: String , LocalizableEnim {
    
    case test = "testLab"
    case findNew = "FindNewLab"
    case findNewSubtitle = "FindNewSubtitleLab"
    case login = "loginLabel"
    case signup = "registerLabel"
    case welcome = "welcomeLabel"
    case welcomeSubtitle = "welcomeSubtitleLabel"
    case createAccount = "createAccountLabel"
    
    var textLib: String {
        return self.localized
    }

}

