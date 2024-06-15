//
//  CloudKitConsoleItemType.swift
//  PassLock
//
//  Created by MELO on 2024/5/29.
//

import KakaFoundation
import AppGroupKit

enum CloudKitConsoleItemType: Int {
    case consoleHead = 0
    case console1 = 1
    case console2 = 2
    case console3 = 3
    
    case console4 = 4
    case console5 = 5
    
    func headStr() -> String? {
        switch self {
        case .consoleHead:
            return nil
        case .console1:
            return "1. All database tables".localStr()
        case .console2:
            return "2. Password - Private database".localStr()
        case .console3:
            return "3. Password - Public database".localStr()
        case .console4:
            return "4. Attachment - Private database".localStr()
        case .console5:
            return "5. Attachment - Public database".localStr()
        }
    }
    
    func footStr() -> String? {
        switch self {
        case .consoleHead:
            return nil
        case .console1:
            return "All important data is keyed to [jsonDataKey]".localStr()
        case .console2:
            return "Querying the private password database in the production environment results in only developer data, and all of it is encrypted with AES256.".localStr()
        case .console3:
            return "Querying the public password database in the production environment results in null.".localStr()
        case .console4:
            return "Similarly, querying the private attachment database in the development environment results in only developer data, and the files are AES256 encrypted.".localStr()
        case .console5:
            return "Querying the public attachment database in the production environment results in null.".localStr()
        }
    }
    
    func cellImage() -> UIImage {
        return Reasource.named("consoles_\(self.rawValue)")
    }
    
}
