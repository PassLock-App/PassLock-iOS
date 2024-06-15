//
//  PasswordViewModel+Empty.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation


extension PasswordViewModel {
    func emptyDataArray() -> [EmptyAccountType] {
        return [.amazingTip, .socialEvents, .privacyReport]
    }
    
    func emptySocialArray() -> [SocialEventModel] {
        
        let model1 = SocialEventModel(newsType: .news1, newsTitle: "One Password for multiple Accounts? Credential Stuffing Could Cost You Everything!".localStr(), coverImage: UIImage(named: "news1"), from: "History of password leakage".localStr())
        let model2 = SocialEventModel(newsType: .news2, newsTitle: "$140 Billion in Bitcoins Unwithdrawable? Those who forgot passwords".localStr(), coverImage: UIImage(named: "news2"), from: "Forgot password".localStr())
        let model3 = SocialEventModel(newsType: .news3, newsTitle: "Private Data, Drug Trafficking, Murder Trade and the Dark Web".localStr(), coverImage: UIImage(named: "news3"), from: "Dark Web and Deep Web".localStr())
        return [model1, model2, model3]
    }
    
    func emptyHeadStrArray() -> [String?] {
        return [nil, "You should know".localStr(), "Privacy Report".localStr()]
    }
    
}
