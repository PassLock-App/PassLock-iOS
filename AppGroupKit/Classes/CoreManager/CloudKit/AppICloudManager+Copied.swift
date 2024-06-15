//
//  AppICloudManager+Copied.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    
    public func savePasswordRecord(_ model: PasswordListModel, success: ((PasswordListModel)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        if 🔒 {
            SandboxFileManager.shared.writePasswordListModel(model)
            success?(model)
            return
        }
        
        let webRecord = model.convertToPassRecord()
        
        let operation = CKModifyRecordsOperation(recordsToSave: [webRecord], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { records, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = records?.first else {
                    SandboxFileManager.shared.writePasswordListModel(model)
                    fail?(error)
                    return
                }
                
                let newModel = firstRecord.convertToPassModel()
                SandboxFileManager.shared.writePasswordListModel(newModel)
                success?(newModel)
            }
        }
        
        self.privateDatabase.add(operation)
    }
    
    public func fetchCopiedPasslist(cursor: CKQueryOperation.Cursor?, success:(([PasswordListModel], CKQueryOperation.Cursor?)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        let locals = SandboxFileManager.shared.readPasswordListModel()
        success?(locals, nil)
        
        if 🔒 {
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        var passlistArray = [PasswordListModel]()
        
        let operation: CKQueryOperation
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: CloudRecordType_CopiedPasswords, predicate: predicate)
            query.sortDescriptors = [sortDescriptor]
            operation = CKQueryOperation(query: query)
        }
        
        operation.recordFetchedBlock = { record in
            let passModel = record.convertToPassModel()
            SandboxFileManager.shared.writePasswordListModel(passModel)
            passlistArray.append(passModel)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error = error as? CKError {
                DispatchQueue.main.async {
                    success?(locals, nil)
                }
                return
            }
                        
            DispatchQueue.main.async {
                success?(passlistArray, cursor)
            }
        }
        
        privateDatabase.add(operation)
        
    }
    
}
