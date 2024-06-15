//
//  AppICloudManager.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/3.
//

import KakaFoundation
import CloudKit
import KakaObjcKit


public typealias UserSuccessCallBack = ((🔒)->Void)
public typealias UserFailedCallBack = ((CKAccountStatus, String?)->Void)

public class AppICloudManager {
        
    // MARK: 🌹 GET && SET 🌹
    public static let shared = AppICloudManager()
    
    public var currentPassbook: AppRecordTypeModel {
        get {
            let bookArray = self.getPassbooks()
            let type = bookArray.filter({ $0.isSelected == true }).first
            return type ?? bookArray[0]
        }
    }

    public init() {
        self.addNotiObservice()
    }
    
    private (set) lazy var keyValueStore: NSUbiquitousKeyValueStore = {
        return NSUbiquitousKeyValueStore.default
    }()
    
    public lazy var sharedDefault: UserDefaults = {
        let sharedUD = UserDefaults(suiteName: appGroupName) ?? UserDefaults.standard
        return sharedUD
    }()
    
    public lazy var privateDatabase: CKDatabase = {
        return defaultContainer.privateCloudDatabase
    }()
    
    public lazy var publicDatabase: CKDatabase = {
        return defaultContainer.publicCloudDatabase
    }()
    
    public lazy var defaultContainer: CKContainer = {
        return CKContainer(identifier: kContainerName)
    }()
    
}

extension AppICloudManager {
    
    public func cancelAccountDeleteData(completion:(()->Void)? = nil) {
        
        let userID = 🔒
        
        let fetchDataGroup = DispatchGroup()
        
        AppLocalManager.reset()
        
        ScreenLockManager.shared.deleteScreenPassCode()
        
        fetchDataGroup.enter()
        self.deletePassbooks { [weak self] () in
            fetchDataGroup.leave()
        }
        
        fetchDataGroup.enter()
        self.deleteAllWebsite() { [weak self] () in
            fetchDataGroup.leave()
        }
        
        fetchDataGroup.enter()
        self.deleteAllPrivateItem(recordType: .defaultBook) { [weak self] () in
            fetchDataGroup.leave()
        }
        fetchDataGroup.enter()
        self.deleteAllPrivateItem(recordType: .familyBook) { [weak self] () in
            fetchDataGroup.leave()
        }
        fetchDataGroup.enter()
        self.deleteAllPrivateItem(recordType: .companyBook) { [weak self] () in
            fetchDataGroup.leave()
        }
        fetchDataGroup.enter()
        self.deleteAllPrivateItem(recordType: .otherBook) { [weak self] () in
            fetchDataGroup.leave()
        }
                
                
        fetchDataGroup.enter()
        self.deleteUserInfo { [weak self] () in
            fetchDataGroup.leave()
        }
        
        fetchDataGroup.notify(queue: .main) { () in
            NotificationCenter.default.post(name: NSNotification.Name(kPostUserInfoChangedKey), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(kUserDidCancelAccountKey), object: nil)
            debugPrint("✅ Delete Success ✅")
            AES256Manager.deleteSymmetricKey(userID)
            completion?()
        }
                        
    }
    
     public func deletePreviousAccountCache() {
         AppLocalManager.reset()
         UserInfoManager.shared.deleteLocalUserCache()
    }
    
}
