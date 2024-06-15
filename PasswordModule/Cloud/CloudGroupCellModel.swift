//
//  CloudGroupCellModel.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import Foundation
import UIKit


struct CloudGroupCellModel {
    
    var group = CloudCellGroupType.syncGroup
    
    var headTitle: String?
    
    var itemArray: [CloudCellItemType] = []
    
    var footTitle: String?
}

enum CloudCellItemType: Int {
    case syncLoclItem = 0
    case deleteCloudItem = 1
    case passwordExtension = 2
    
    case compressImage = 3
    case autoDeleteTips = 4
    case autoSyncCloud = 5
            
    func titleStr() -> String? {
        switch self {
        case .syncLoclItem:
            return "Sync local items".localStr()
        case .deleteCloudItem:
            return "Delete iCloud items".localStr()
        case .passwordExtension:
            return UserCellItemType.autofill.titleStr()
            
        case .compressImage:
            return "Auto-compress photos".localStr()
        case .autoDeleteTips:
            return "Auto-delete original data".localStr()
        case .autoSyncCloud:
            return "Auto sync to iCloud".localStr()
        }
    }
    
    func iconImage() -> UIImage? {
        switch self {
        case .syncLoclItem:
            return UIImage(systemName: "icloud.slash")
        case .deleteCloudItem:
            return UIImage(systemName: "icloud")
        case .passwordExtension:
            return UserCellItemType.autofill.cellImage()
            
        case .compressImage:
            return nil
        case .autoDeleteTips:
            return nil
        case .autoSyncCloud:
            return nil
        }
    }
    
}
