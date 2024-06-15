//
//  MacTabbarCellModel.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit

struct MacTabbarCellModel {
    
    var group = MacTabbarCellType.otherGroup
    
    var headTitle: String?
    
    var itemArray: [MacTabbarCellItemType] = []
    
    var footTitle: String?
    
}

enum MacTabbarCellItemType: String {
    
    case currentvault = "currentvault"
    
    case allItems  = "allItems"
    case loginItems  = "loginItems"
    case fileItems  = "fileItems"
    case noteItems  = "noteItems"
    
    case strongPass  = "stringPass"
    case transparency  = "transparency"
    case downloadIOS  = "downloadIOS"
    case addItems  = "addItems"
    
    case userCenter = "userCenter"
    
    func formatStr() -> String {
        switch self {
        case .currentvault: return ""
            
        case .allItems: return StorageItemType.allItem.nameStr()
        case .loginItems: return StorageItemType.password.nameStr()
        case .fileItems: return StorageItemType.photoVault.nameStr()
        case .noteItems: return StorageItemType.secretNotes.nameStr()
        
        case .strongPass: return KakaTabbarItem.creater.formatStr()
        case .transparency: return KakaTabbarItem.developer.formatStr()
        case .downloadIOS: return "Download for iOS".localStr()
        case .addItems: return ""
            
        case .userCenter: return KakaTabbarItem.profile.formatStr()
        }
    }
    
    func iconImage() -> UIImage? {
        switch self {
        case .currentvault:
            return AppRecordType.defaultBook.recordIconImage()
            
        case .allItems:
            return StorageItemType.allItem.systemIconImage()
        case .loginItems:
            return StorageItemType.password.systemIconImage()
        case .fileItems:
            return StorageItemType.photoVault.systemIconImage()
        case .noteItems:
            return StorageItemType.secretNotes.systemIconImage()
        case .strongPass:
            return Reasource.systemNamed("ellipsis.rectangle", color: appMainColor)
        case .transparency:
            return Reasource.systemNamed("quote.bubble", color: appMainColor).flippedImage()
        case .downloadIOS:
            if #available(iOS 16.1, *) {
                return Reasource.systemNamed("macbook.and.iphone", color: appMainColor)
            }else{
                return Reasource.systemNamed("iphone", color: appMainColor)
            }
        case .addItems: return nil
            
        case .userCenter: return nil
        }
    }
}


