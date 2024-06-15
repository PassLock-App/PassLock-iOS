//
//  AddItemCellModel.swift
//  PassLock
//
//  Created by melo on 2024/6/2.
//

import KakaFoundation
import AppGroupKit

enum AddItemCellModelType: Int {
    case titleGroup = 0
    case passwordGroup = 1
    case notesGroup = 2
    case attachGroup = 3
}

struct AddItemCellModel {
    
    var group = AddItemCellModelType.titleGroup
    
    var headTitle: String?
    
    var itemArray: [AddItemType] = []
    
    var footTitle: String?
}

enum AddItemType: Int {
    case customTitle = 0
    
    case userName = 1
    case password = 2
    case website  = 3
    
    case notes = 4
    case attachs = 5
    
    func leftIconImage() -> UIImage? {
        switch self {
        case .customTitle:
            return Reasource.systemNamed("at.badge.plus", color: appMainColor)
            
        case .userName:
            return Reasource.systemNamed("person.icloud", color: appMainColor)
        case .password:
            return Reasource.systemNamed("key.icloud", color: appMainColor)
        case .website:
            return Reasource.systemNamed("link", color: appMainColor)
            
        case .notes:
            return nil
            
        case .attachs:
            return nil
        }
    }
    
}
