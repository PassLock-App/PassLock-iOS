//
//  AppICloudManager+Avatar.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/9.
//

import KakaFoundation
import KakaObjcKit
import CloudKit

extension AppICloudManager {

    public func syncPrivateAndPublicUser(userModel: 🔒, completion: (()->Void)? = nil) {
        
        let privateOperation = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: nil)
        privateOperation.isAtomic = true
        privateOperation.savePolicy = .changedKeys
        
        privateOperation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            guard let firstRecord = savedRecords?.first else { return }
                        
            completion?()
        }
                    
        self.privateDatabase.add(privateOperation)
        
        
        let publicOperation = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: nil)
        publicOperation.isAtomic = true
        publicOperation.savePolicy = .changedKeys
                    
        self.publicDatabase.add(publicOperation)
    }
    
}

extension AppICloudManager {

    public func checkRemoteAvatar(_ model: 🔒, completion:((RemoteAvatarModel)->Void)? = nil, fail: ((String?)->Void)? = nil) {
        guard let remoteAvatar = model.remoteAvatar, remoteAvatar.count > 0 else {
            fail?(nil)
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.modificationDate, ascending: true)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(format: "🔒 = %@", 🔒)
        let query = CKQuery(recordType: CloudRecordType_RemoteAvatar, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]

        privateDatabase.perform(query, inZoneWith: .default) { (records, error) in
            guard let firstRecord = records?.first else {
                DispatchQueue.main.async {
                    fail?(error?.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                let avatarRecord = firstRecord.convertRemoteAvatarModel()
                completion?(avatarRecord)
                
                guard let image = avatarRecord.remote_avatar?.asCKAsset()?.assetImage() else { return }
                let _ = SandboxFileManager.shared.saveAvatarImageSanbox(userModel: model, image: image)
            }
        }
        
    }
    
    public func uploadRemoteAvatar(avatarModel: RemoteAvatarModel, success: ((String)->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        let avatarRecord = avatarModel.convertAvatarRecord()
        
        let operation = CKModifyRecordsOperation(recordsToSave: [avatarRecord], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = savedRecords?.first else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                success?(firstRecord.recordID.recordName)
            }
        }
        
        self.privateDatabase.add(operation)
        
    }
    
    public func deleteRemoteAvatar(userModel: 🔒, success: (()->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        guard let remoteAvatar = userModel.remoteAvatar, remoteAvatar.count > 1 else {
            fail?("AVATAR ID NULL")
            return
        }
        
        let avatarID = CKRecord.ID(recordName: remoteAvatar)
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [avatarID])
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecordID = recordIds?.first else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                success?()
            }
        }
        
        self.privateDatabase.add(operation)
    }
}
