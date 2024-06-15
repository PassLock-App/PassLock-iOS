//
//  AutoFillPasswordStep.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit

enum AutoFillPasswordStep: Int {
    case guideStep1 = 1
    case guideStep2 = 2
    case guideStep3 = 3
    
    func headStr() -> String? {
        switch self {
        case .guideStep1:
            return "1. Enable the option in Password Options as shown here".localStr()
        case .guideStep2:
            return "2. Once you set up the URL, the system will recommend the most accurate account for you based on the URL.".localStr()
        case .guideStep3:
            return "3. If the URL is associated with multiple accounts, the system will recommend multiple accounts for you".localStr()
        }
    }
    
    func footStr() -> String? {
        switch self {
        case .guideStep1:
            return ""
        case .guideStep2:
            return "This is why we strongly recommend that you should set a URL for each account".localStr()
        case .guideStep3:
            return "Some applications may not display the recommended accounts, often because they haven't set the corresponding URL. However, you can still manually select accounts through our extension. Additionally, you can choose from your history of passwords.".localStr()
        }
    }
    
    func cellImage() -> UIImage {
        switch self {
        case .guideStep1:
            let iosName = PhoneSetManager.formatLanguage() == .chinese_simplified ? "autofill_ios_set_cn" : "autofill_ios_set_en"
            let macName = PhoneSetManager.formatLanguage() == .chinese_simplified ? "autofill_mac_set_cn" : "autofill_mac_set_en"
            return Reasource.named(kaka_IsMacOS() ? macName : iosName)
        case .guideStep2:
            return Reasource.named("autofill_ios_guide_1")
        case .guideStep3:
            return Reasource.named("autofill_ios_guide_2")
        }
    }
    
}
