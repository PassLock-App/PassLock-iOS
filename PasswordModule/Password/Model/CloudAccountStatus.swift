//
//  CloudAccountStatus.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import Foundation

enum CloudAccountStatus: Int {
    
    case networkUnable = -1
    
    case couldNotDetermine = 0

    case available = 1

    case restricted = 2

    case noAccount = 3

    case temporarilyUnavailable = 4
    
    func formatStr() -> String {
        var message = ""
        switch self {
        case .networkUnable:
            message = "The network seems to be disconnected".localStr()
        case .couldNotDetermine:
            message = "iCloud exception".localStr()
        case .available:
            message = "iCloud is ready".localStr()
        case .restricted:
            message = "Your iCloud is subject to system restrictions".localStr()
        case .noAccount:
            message = "You haven‘t login to iCloud".localStr()
        case .temporarilyUnavailable:
            message = "Your iCloud is currently unavailable".localStr()
        }
        
        return message
    }
    
    func solutionStr() -> String {
        var message = ""
        switch self {
        case .networkUnable:
            message = "Possibly you have not enabled Wi-Fi and cellular data permissions, please go to Settings and authorize".localStr()
        case .couldNotDetermine:
            message = "Your iCloud account is temporarily invalid and you may need to sign in again. Please contact customer service or click the link below to view Apple's official technical guide.".localStr()
        case .available:
            message = ""
        case .restricted:
            message = "Your iCloud is restricted, please contact our customer service or click the link below to view Apple's official technical guide.".localStr()
        case .noAccount:
            message = "Please go to Settings to check the login status of iCloud Drive, please refer to the attached image below.".localStr()
        case .temporarilyUnavailable:
            message = "Your iCloud is temporarily unavailable, please contact customer service or click the link below to view Apple's official technical guide.".localStr()
        }
        
        return message
    }
    
}
