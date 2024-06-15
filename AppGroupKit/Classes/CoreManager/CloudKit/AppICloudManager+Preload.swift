//
//  AppICloudManager+Preload.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/9.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    public func preloadPassFileAsset() {
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudRecordType_PasswordFile, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        var remoteArray = [CKRecord]()
        let aesKey = 🔒
        
        func fetchRecords(cursor: CKQueryOperation.Cursor?) {
            let operation: CKQueryOperation
            
            if let cursor = cursor {
                operation = CKQueryOperation(cursor: cursor)
            } else {
                operation = CKQueryOperation(query: query)
            }
            
            operation.recordFetchedBlock = { record in
                remoteArray.append(record)
                if var subModel = record.convertFileAssetModel(aesKey) {
                    SandboxFileManager.shared.writePassFileAsset(subModel)
                }
            }
            
            operation.queryCompletionBlock = { cursor, error in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        return
                    }
                    
                    if let cursor = cursor {
                        fetchRecords(cursor: cursor)
                    } else {
                        SandboxFileManager.shared.fileRecordArray = remoteArray
                    }
                }
            }
            
            privateDatabase.add(operation)
        }
        
        fetchRecords(cursor: nil)
    }
    
    
    public func preloadRemoteWebsite(_ completion: (([WebsiteInfoModel])->Void)? = nil) {
                
        let locals = SandboxFileManager.shared.readPrivateWebsiteModel()
        completion?(locals)
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.modificationDate, ascending: true)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudRecordType_Website, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        var websiteArray = [WebsiteInfoModel]()
        
        func fetchRecords(cursor: CKQueryOperation.Cursor?) {
            let operation: CKQueryOperation
            
            if let cursor = cursor {
                operation = CKQueryOperation(cursor: cursor)
            } else {
                operation = CKQueryOperation(query: query)
            }
            
            operation.recordFetchedBlock = { record in
                var webModel = record.convertPrivateWebsite()
                webModel.isSyncCloud = true
                websiteArray.append(webModel)
                SandboxFileManager.shared.writePrivateWebsiteModel(webModel)
            }
            
            operation.queryCompletionBlock = { cursor, error in
                if let error = error {
                    return
                }
                
                if let cursor = cursor {
                    fetchRecords(cursor: cursor)
                } else {
                    DispatchQueue.main.async {
                        completion?(websiteArray)
                    }
                }
            }
            
            privateDatabase.add(operation)
        }
        
        fetchRecords(cursor: nil)
    }
    
}
