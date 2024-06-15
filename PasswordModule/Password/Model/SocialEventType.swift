//
//  SocialEventType.swift
//  PassLock
//
//  Created by Melo on 2024/6/10.
//

import KakaFoundation

enum SocialContentType: Int {
    
    case guideType = 0
    case realEventType = 1
    case endType = 2
    
    
    func titleStr(_ newsType: SocialEventType) -> String? {
        switch self {
        case .guideType:
            return nil
        case .realEventType:
            return "Related Cases".localStr()
        case .endType:
            return nil
        }
    }
    
    func contentStr(_ newsType: SocialEventType) -> String? {
        switch self {
        case .guideType:
            if newsType == .news1 {
                return "From social media to banking, we have numerous accounts, each requiring a password. For convenience, many people use the same password across multiple sites. However, this seemingly harmless habit can have disastrous consequences due to a technique known as credential stuffing.".localStr()
            }else if newsType == .news2 {
                return "Everyone has had the experience of a forgotten password, and no one likes that experience. However, due to not managing their passwords properly, many people with huge fortunes in their hands are unable to withdraw their bitcoins. This situation is not only saddening, but it also serves as an important wake-up call to use a password manager.".localStr()
            }else{
                return "During our daily use of our phones, many apps request access to our photo albums and location information. While these permissions are reasonable in some cases, some apps may frequently read your photo albums without your knowledge, recognize sensitive photos through AI, and upload them to their private servers.".localStr()
            }
        case .realEventType:
            return nil
        case .endType:
            if newsType == .news1 {
                return "Using the same password for all accounts is a risky practice that can lead to disastrous consequences. By taking proactive steps to protect your online presence, you can protect yourself from the costly and damaging effects of a crash database. Stay safe online and remember that security begins with using unique strong passwords for each account.".localStr()
            }else if newsType == .news2 {
                return "These hard lessons resulting from forgotten passwords remind us that it is vital to manage passwords properly. By using a password manager, you can securely store and manage passwords for all your accounts and avoid the huge losses that can result from forgetting passwords. Staying safe online starts with the use of a password manager to ensure that your digital wealth is always under your control.".localStr()
            }else{
                return "These cases reveal the great dangers and horrors of the dark web. Once your personal information, photos and financial data are compromised, they may be used for a variety of illegal and malicious activities, bringing endless troubles and threats to you and your family. With Apple Privacy Report, we can learn about the privacy violations that apps may be performing in the background. Stay vigilant and use strong password managers and privacy protection tools to ensure that your personal information and financial data are always safe.".localStr()
            }
        }
    }
    
}

struct RealEventModel {
    var title: String = ""
    var content: String = ""
    
    static func model(_ newsType: SocialEventType) -> [RealEventModel] {
        switch newsType {
        case .news1:
            let model1 = RealEventModel(title: "1. The LinkedIn Data Breaches".localStr(), content: "In 2012, LinkedIn suffered a massive data breach that exposed millions of user credentials. Years later, in 2016, the full extent of the breach became clear when 117 million email and password combinations were found for sale on the dark web. Attackers used these credentials to perform credential stuffing attacks on various other platforms, resulting in numerous accounts being compromised.".localStr())
            let model2 = RealEventModel(title: "2. The Yahoo Data Breaches".localStr(), content: "Yahoo experienced multiple data breaches, with one in 2013 affecting over 3 billion accounts. The stolen credentials were used in credential stuffing attacks on other popular services, causing widespread damage and financial loss for individuals and organizations alike.".localStr())
            let model3 = RealEventModel(title: "3. Facebook's Data Breach".localStr(), content: "Facebook had repeated data breaches in 2018, 2019, and 2021, cumulatively affecting the data of 1.6 billion users, including including users' phone numbers, Facebook IDs, full names, locations, dates of birth, email addresses, and more. It was mentioned in the 2018 Cambridge Analytica incident that it influenced the 2016 US presidential election and was eventually fined $5 billion.".localStr())
            return [model1, model2, model3]
        case .news2:
            let model1 = RealEventModel(title: "1. The story of Stefan Thomas".localStr(), content: "Stefan Thomas is a programmer who owns 7,002 bitcoins worth approximately $240 million. The bitcoins are locked away on the IronKey hard drive because he forgot the password to the drive.The IronKey hard drive allows the user to enter the password a limited number of times, and if the limit is exceeded, the drive permanently encrypts the data making it unrecoverable.Thomas has attempted the password 8 times and has failed, leaving him with only 2 chances left.".localStr())
            let model2 = RealEventModel(title: "2. Blunder by James Howells".localStr(), content: "In 2013, James Howells accidentally threw away an old computer with a hard drive containing 7,500 bitcoins. The bitcoins are now worth more than $250 million, and Howells' repeated requests to local authorities to search the landfill for the hard drive have been denied. Though he is willing to pay a high fee to conduct the search, there is still little hope of recovering the hard drive.".localStr())
            let model3 = RealEventModel(title: "3. Experience of Mark Frauenfelder".localStr(), content: "Technical writer Mark Frauenfelder was once unable to access his cryptocurrency wallet because he forgot his password. After many attempts and frustrations, he finally got his password back with the help of a password recovery company. But in the process, he experienced a great deal of stress and anxiety.".localStr())
            return [model1, model2, model3]
        case .news3:
            let model1 = RealEventModel(title: "1. Illegal dark web marketplaces".localStr(), content: "On the dark web, large amounts of personal information, financial data and sensitive photos are openly bought and sold. A well-known case was in 2018, when a hacker sold 50 million pieces of user data stolen from an app on the dark web, including names, addresses, photo IDs and bank card information. The information was used for a variety of illegal activities, from identity theft to financial fraud.".localStr())
            let model2 = RealEventModel(title: "2. Human trafficking".localStr(), content: "The dark web is not only a hotbed of illegal information trading, but is also involved in human trafficking.In 2017, a trafficker was arrested for purchasing a large amount of women's personal information, including photographs and addresses, through the dark web, and using the information to kidnap and sell them.".localStr())
            let model3 = RealEventModel(title: "3. Drug trade".localStr(), content: "The drug trade is rampant on the dark web, and in 2019, U.S. law enforcement agencies shut down a dark web marketplace called Silk Road 2.0, where hundreds of millions of dollars of drugs were being traded. Sellers and buyers alike rely on anonymized personal information to circumvent the law.".localStr())
            return [model1, model2, model3]
        }
    }
}

