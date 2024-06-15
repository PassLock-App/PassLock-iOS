//
//  AppICloudManager+Login.swift
//  AppGroupKit
//
//  Created by Melo on 2024/3/14.
//

import KakaFoundation
import CloudKit


extension AppICloudManager {
    
    public func fetchCurrentUserRecord(isPublic: Bool, 🔒: String, success: ((CKRecord)->Void)? = nil, fail: ((CKError?)->Void)? = nil) {
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(format: "🔒 = %@", 🔒)
        let query = CKQuery(recordType: CloudRecordType_AllUser, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]

        (isPublic ? publicDatabase : privateDatabase).perform(query, inZoneWith: .default) { (records, error) in
            guard let firstRecord = records?.first else {
                DispatchQueue.main.async {
                    fail?(error as? CKError)
                }
                return
            }
            
            DispatchQueue.main.async {
                success?(firstRecord)
            }
        }
         
    }
    
    public func registerUser(user: 🔒, success: ((CKRecord)->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        let userRecord = user.convertPublicUserRecord()
        
        let operation = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = savedRecords?.first else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                self.syncPrivateAndPublicUser(userModel: user)
                success?(firstRecord)
            }
        }
        
        self.privateDatabase.add(operation)
    }
    
    public func deleteUserInfo(success: (()->Void)? = nil, fail: ((String?)->Void)? = nil) {

        guard var vUserModel = 🔒 else {
            fail?(nil)
            return
        }
        
        if let remoteAvatar = vUserModel.remoteAvatar {
            self.privateDatabase.delete(withRecordID: CKRecord.ID(recordName: remoteAvatar)) { id, error in
                
            }
        }
        
        self.syncPrivateAndPublicUser(userModel: vUserModel) {
            success?()
        }
    }
    
}
