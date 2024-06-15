//
//  AppRecordTypeModel.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/19.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import CloudKit
import HandyJSON


public enum StorageItemType: String, HandyJSONEnum {
    
    case allItem = "allItem"
    case password = "password"
    case photoVault = "photoVault"
    case secretNotes = "secretNotes"

    case bankCard = "bankCard"
    case secretContacts = "secretContacts"
    case database = "database"
    case service  = "service"
    case customerInfo = "customerInfo"
    case APICredentials = "APICredentials"
    case SSHKey = "SSHKey"

    public func systemIconImage() -> UIImage? {
        switch self {
        case .allItem:
            return UIImage(systemName: "square.grid.2x2")
        case .password:
            return UIImage(systemName: "lock.rectangle.stack")
        case .photoVault:
            return UIImage(systemName: "lock.doc")
        case .secretNotes:
            return UIImage(systemName: "note.text")?.flippedImage()
            
        case .bankCard:
            return UIImage(systemName: "building.columns")
        case .secretContacts:
            if #available(iOS 15.0, *) {
                return UIImage(systemName: "person.text.rectangle")
            }else{
                return UIImage(systemName: "person.crop.rectangle")
            }
        case .database:
            return UIImage(systemName: "externaldrive.badge.icloud")
        case .service:
            return nil
        case .customerInfo:
            return nil
        case .APICredentials:
            return nil
        case .SSHKey:
            return nil
        }
    }
    
    public func typeImage() -> UIImage? {
        switch self {
        case .photoVault:
            return UIImage(systemName: "paperclip.badge.ellipsis")
        default:
            return nil
        }
    }
    
}
