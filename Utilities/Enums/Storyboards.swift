
import Foundation


enum Storyboards: String {
    case Main
    case Onboarding
    case Welcome
    
    var stName: String {
        return self.rawValue
    }
}
