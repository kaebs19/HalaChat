
import Foundation


enum Lables: String  {
    
    case findNew = "FindNewLab"
    case findNewSubtitle = "FindNewSubtitleLab"
    case login = "loginLabel"
    case signup = "registerLabel"
    case welcome = "welcomeLabel"
    case welcomeSubtitle = "welcomeSubtitleLabel"
    case createAccount = "createAccountLabel"
    case argeement = "argeementLabel"
    case iAgree = "iAgreeLabel"
    case forgotPasswordSubtitle = "forgotPasswordSubtitleLabel"
    case Logout = "LogoutLable"
    case qrCodeSubtitle = "qrCodeSubtitleLabel"
    case lightMode = "lightModeLabel"
    case darkMode = "darkModeLabel"
   case  selectLanguage = "selectLanguageLabel"
    
    var textLib: String {
        return self.rawValue.localized
    }

}

