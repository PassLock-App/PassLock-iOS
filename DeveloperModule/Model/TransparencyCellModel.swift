//
//  TransparencyCellModel.swift
//  PassLock
//
//  Created by MELO on 2024/5/29.
//

import KakaFoundation
import AppGroupKit

enum TransparencyCellGroupType: Int {
    case transparency = 0
    case others = 1
}

struct TransparencyCellModel {
    
    var group = TransparencyCellGroupType.transparency
    
    var headTitle: String?
    
    var itemArray: [TransparencyItemType] = []
    
    var footTitle: String?
}

enum TransparencyItemType: Int {
    case openSource = 0
    case iCloudBackup = 1
    case producuStory = 2
    
    case faqs = 3
    case contactMail = 4
    
    func titleStr() -> String {
        switch self {
        case .openSource:
            return "Open source code".localStr()
        case .iCloudBackup:
            return "Console Demo".localStr()
        case .producuStory:
            return "Early Story".localStr()
            
        case .faqs:
            return "FAQs".localStr()
        case .contactMail:
            return "E-Mail".localStr()
        }
    }
    
    func cellImage() -> UIImage {
        switch self {
        case .openSource:
            if #available(iOS 15.0, *) {
                return Reasource.systemNamed("ellipsis.curlybraces", color: appMainColor)
            }else{
                return Reasource.systemNamed("swift", color: appMainColor)
            }
        case .iCloudBackup:
            return Reasource.systemNamed("text.quote", color: appMainColor).sfHorizontallyImage()
        case .producuStory:
            return Reasource.systemNamed("book", color: appMainColor)
            
        case .faqs:
            return Reasource.systemNamed("questionmark.circle", color: appMainColor).flippedImage()
        case .contactMail:
            return Reasource.systemNamed("envelope.badge", color: appMainColor).flippedImage()
        }
    }
    
}
