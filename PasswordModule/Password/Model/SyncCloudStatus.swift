//
//  SyncCloudStatus.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import UIKit

enum SyncCloudStatus: Int {
    case unScyn = 0
    case syncing = 1
    case warning = 2
    case completion = 3
    
    func backgroundColor() -> UIColor {
        switch self {
        case .unScyn:
            return UIColor.red
        case .syncing:
            return UIColor.systemGreen
        case .warning:
            return UIColor.orange
        case .completion:
            return UIColor.systemGreen
        }
    }
    
    func syncImage() -> UIImage? {
        switch self {
        case .unScyn:
            return UIImage(named: "cloud_error")?.withTintColor(.label)
        case .syncing:
            return UIImage(named: "cloud_sync")?.withTintColor(.label)
        case .warning:
            return UIImage(named: "cloud_warn")?.withTintColor(.label)
        case .completion:
            return UIImage(named: "cloud_success")?.withTintColor(.label)
        }
    }
    
    func syncStatusStr() -> String {
        switch self {
        case .unScyn:
            return "Local only, please sync".localStr()
        case .syncing:
            return "Synchronizing".localStr()
        case .warning:
            return "Some items not synced".localStr()
        case .completion:
            return "Synchronized".localStr()
        }
    }
    
    func syncStatusColor() -> UIColor {
        switch self {
        case .unScyn:
            return UIColor.red
        case .syncing:
            return UIColor.secondaryLabel
        case .warning:
            return UIColor.orange
        case .completion:
            return UIColor.secondaryLabel
        }
    }
}
