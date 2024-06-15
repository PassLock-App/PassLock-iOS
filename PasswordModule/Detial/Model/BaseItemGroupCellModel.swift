//
//  BaseItemGroupCellModel.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation


enum PrivateCellItemType: String {
    case icontitle = "icontitle"
    
    case userName = "userName"
    case password = "password"
    case vaultType = "vaultType"
    case darkweb  = "darkweb"
    
    case websiteURL   = "websiteURL"
    case websiteModify = "websiteModify"
    
    case otherNote = "otherNote"
    
    case otherAttach = "otherAttach"
    
    case safeReport = "safeReport"
    case shareAction = "shareAction"
    case deleteAction = "deleteAction"
    case starAction = "starAction"
    case syncAction = "syncAction"
    
    
    func iconImage(_ isBool: Bool = false) -> UIImage? {
        switch self {
        case .icontitle: return nil
        case .userName: return nil
        case .password: return nil
        case .vaultType: return nil
        case .darkweb: return nil
        case .websiteURL: return nil
        case .websiteModify: return nil
        case .otherNote: return nil
        case .otherAttach: return nil
            
        case .safeReport: return UIImage(systemName: "shield")?.withTintColor(appMainColor)
            
        case .shareAction: return UIImage(systemName: "square.and.arrow.up")?.withTintColor(appMainColor)
        case .deleteAction: return UIImage(systemName: "trash")?.withTintColor(appMainColor)
        case .starAction: return UIImage(systemName: isBool ? "star.fill" : "star")?.withTintColor(appMainColor)
        case .syncAction: return UIImage(systemName: "arrow.triangle.2.circlepath")?.withTintColor(appMainColor)
            
        }
    }
    
    func formatTitle(_ isBool: Bool = false) -> String? {
        switch self {
        case .icontitle: return nil
        case .userName: return nil
        case .password: return nil
        case .vaultType: return nil
        case .darkweb: return nil
        case .websiteURL: return nil
        case .websiteModify: return nil
        case .otherNote: return nil
        case .otherAttach: return nil
            
            
        case .safeReport: return "Security Level".localStr()
        case .shareAction: return "Share".localStr()
        case .deleteAction: return "Delete".localStr()
        case .starAction: return isBool ? "Cancel Favorites".localStr() : "Favorite".localStr()
        case .syncAction: return "Sync to iCloud".localStr()
            
        }
    }
    
}
