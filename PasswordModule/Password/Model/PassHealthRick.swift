//
//  PassHealthRick.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import Foundation
import HandyJSON

enum PassHealthRick: Int, HandyJSONEnum {
    case allData  = 0
    case securety = 1
    case easyGuess = 2
    case duplicate = 3  
    
    func formatStr() -> String {
        switch self {
        case .allData:
            "All"
        case .securety:
            "strong".localStr()
        case .easyGuess:
            "risky".localStr()
        case .duplicate:
            "duplicate".localStr()
        }
    }
    
    func statusImage() -> UIImage {
        switch self {
        case .allData:
            return Reasource.named("pass_strong")
        case .securety:
            return Reasource.named("pass_strong")
        case .easyGuess:
            return Reasource.named("pass_easy")
        case .duplicate:
            return Reasource.named("pass_repeat")
        }
    }
    
    func descStr(_ count: Int) -> String {
        switch self {
        case .allData:
            return ""
        case .securety:
            return "Strong password: contains uppercase and lowercase letters, numbers, special characters, and must be updated within 6 months".localStr() + "✅      "
        case .easyGuess:
            return "Risky password: A weak password or one that has not been updated within half a year has potential risks and it is recommended to change it.".localStr() + "⚠️      "
        case .duplicate:
            return "Duplicate password: The current password is duplicated with other accounts. It is a very dangerous password. It is strongly recommended to change it.".localStr() + "❗️      "
        }
    }
    
    func reasonStr() -> String {
        switch self {
        case .allData:
            return ""
        case .securety:
            return "This account is using strong password: it contains uppercase and lowercase letters, numbers, special characters, and has been updated within half a year.".localStr()
        case .easyGuess:
            return "There are potential risks in the account. Reason: You are using a weak password or it has not been updated in six months. Please synchronize it to PassLock after changing the password to a strong one on the account platform.".localStr()
        case .duplicate:
            return "There are obvious risks in the account. Reason: The current password is the same password used by other accounts. Please synchronize it to PassLock after changing the password to a strong one on the account platform.".localStr()
        }
    }
    
    func healthColor() -> UIColor {
        switch self {
        case .allData:
            return UIColor.clear
        case .securety:
            return UIColor.systemGreen
        case .easyGuess:
            return UIColor.systemOrange
        case .duplicate:
            return UIColor.systemPink
        }
    }
        
}
