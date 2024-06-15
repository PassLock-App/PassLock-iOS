//
//  AppICloudManager+ItemDelete.swift
//  AppGroupKit
//
//  Created by Melo on 2024/1/13.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    
    public func deleteMultipleRecords(models: [PrivateBaseItemModel], isDeleteLocal: Bool = true, success: (([PrivateBaseItemModel])->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        let deleteGroup = DispatchGroup()
        var deleteError: Error?
        var deleteArray = [PrivateBaseItemModel]()
        
        for subModel in models {
            deleteGroup.enter()
            if subModel.isSyncCloud {
                
                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [CKRecord.ID(recordName: subModel.recordId)])
                operation.modifyRecordsCompletionBlock = { records, deletedRecordIDs, error in
                    DispatchQueue.main.async {
                        guard let firstRecordID = deletedRecordIDs?.first else {
                            debugPrint("🍎 Delete Item = \(error?.localizedDescription ?? "✅")")
                            deleteError = error
                            deleteGroup.leave()
                            return
                        }
                        
                        deleteArray.append(subModel)
                        self.deleteRemoteAsset([subModel])
                        
                        if isDeleteLocal {
                            self.deletePasswordToExtension(subModel)
                            SandboxFileManager.shared.deletePrivateItemModel(subModel, isDeleteAsset: true)
                        }else{
                            var updateModel = subModel
                            updateModel.isSyncCloud = false
                            
                            self.updatePasswordToExtension(updateModel)
                            SandboxFileManager.shared.saveOrUpdateItemModel(updateModel)
                        }
                        
                        deleteGroup.leave()
                    }
                }
                
                privateDatabase.add(operation)
            }else{
                deleteArray.append(subModel)
                if isDeleteLocal {
                    self.deletePasswordToExtension(subModel)
                    SandboxFileManager.shared.deletePrivateItemModel(subModel, isDeleteAsset: true)
                }
                
                debugPrint("Delete Local Item = \(subModel.customTitle ?? "")")
                deleteGroup.leave()
            }
        }
        
        deleteGroup.notify(queue: .main) {
            guard let error = deleteError else {
                success?(deleteArray)
                return
            }
            
            fail?(error)
        }
    }
    
}


extension AppICloudManager {
    
    public func deleteAllPrivateItem(recordType: AppRecordType, completion: (()->Void)? = nil) {
        
        if 🔒 {
            let localArray = SandboxFileManager.shared.readPrivateItemModels(recordType: recordType, itemType: .allItem)
            for subModel in localArray {
                SandboxFileManager.shared.deletePrivateItemModel(subModel, isDeleteAsset: true)
            }
            
            completion?()
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        var allItemArray = [PrivateBaseItemModel]()
        
        func fetchRecords(cursor: CKQueryOperation.Cursor?) {
            let operation: CKQueryOperation
            
            if let cursor = cursor {
                operation = CKQueryOperation(cursor: cursor)
            } else {
                operation = CKQueryOperation(query: query)
            }
            
            operation.recordFetchedBlock = { record in
                let itemModel = record.convertToAccountModel()
                SandboxFileManager.shared.deletePrivateItemModel(itemModel, isDeleteAsset: true)
                allItemArray.append(itemModel)
            }
            
            operation.queryCompletionBlock = { cursor, error in
                if let error = error {
                    completion?()
                    return
                }
                
                if let cursor = cursor {
                    fetchRecords(cursor: cursor)
                } else {
                    self.deleteRemoteAsset(allItemArray)
                    self.deletePassType(itemArray: allItemArray, complection: completion)
                }
            }
            
            privateDatabase.add(operation)
        }
        
        fetchRecords(cursor: nil)
         
    }
    
    private func deletePassType(itemArray: [PrivateBaseItemModel], complection: (()->Void)? = nil) {
        
        if itemArray.count == 0 {
            complection?()
            return
        }
        
        let recordIDsToDelete = itemArray.map { CKRecord.ID(recordName: $0.recordId) }
                
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete)
        operation.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
            complection?()
        }
        
        privateDatabase.add(operation)
    }
    
    internal func deleteRemoteAsset(_ models: [PrivateBaseItemModel]) {
        
        let allAssetIds: [String] = models.compactMap { $0.assetIdArray }.flatMap { $0 }
        
        if allAssetIds.count == 0 { return }
                
        let deleteIDs = allAssetIds.map { CKRecord.ID(recordName: $0) }
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: deleteIDs)
        operation.isAtomic = true
        operation.savePolicy = .allKeys
        
        operation.modifyRecordsCompletionBlock = { records, deletedRecordIDs, error in
            debugPrint("Delete Remote Attachs = \(error?.localizedDescription ?? "✅")")
        }
        
        privateDatabase.add(operation)
    }
}
