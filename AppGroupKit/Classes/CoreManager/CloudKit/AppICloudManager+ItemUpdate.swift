//
//  AppICloudManager+ItemUpdate.swift
//  AppGroupKit
//
//  Created by Melo on 2024/1/13.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    
    public func updateOnePrivateItem(model: PrivateBaseItemModel, originalModel: PrivateBaseItemModel? = nil, success: ((PrivateBaseItemModel)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        if let originalModel = originalModel, let originalIdArray = originalModel.assetIdArray, originalIdArray.count > 0 {
            
            let nowIdArray = model.assetIdArray ?? []
            
            let filtArray = self.filterStringArray(arrayA: originalIdArray, notContainingIn: nowIdArray)
            
            if originalModel.isSyncCloud {
                var deleteModel = PrivateBaseItemModel()
                deleteModel.recordId = originalModel.recordId
                deleteModel.assetIdArray = filtArray
                self.deleteRemoteAsset([deleteModel])
            }
            
            filtArray.map { fileID in
                var deleteFile = SingleFileModel()
                deleteFile.recordId = fileID
                deleteFile.recordType = model.recordType
                SandboxFileManager.shared.deleteSingleFile(model: deleteFile)
            }
        }
        
        if model.isSyncCloud {
            
            guard let assetArray = model.fileAssetRecords(), assetArray.count > 0 else {
                self.updateItemModel(model: model, success: success, fail: fail)
                return
            }
            
            let operation = CKModifyRecordsOperation(recordsToSave: assetArray, recordIDsToDelete: nil)
            operation.isAtomic = true
            operation.savePolicy = .changedKeys
            
            operation.modifyRecordsCompletionBlock = { records, recordIds, error in
                                
                guard let records = records, records.count > 0 else {
                    DispatchQueue.main.async {
                        fail?(error)
                    }
                    return
                }
                
                let recordIdArray = records.map { $0.recordID.recordName }
                var tempModel = model
                tempModel.isSyncCloud = true
                tempModel.assetIdArray = recordIdArray
                self.updateItemModel(model: tempModel, success: success, fail: fail)
            }
            
            self.privateDatabase.add(operation)
            
        }else{
            SandboxFileManager.shared.saveOrUpdateItemModel(model)
            self.updatePasswordToExtension(model)
            success?(model)
            NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: model, userInfo: nil)
        }
    }
    
    private func updateItemModel(model: PrivateBaseItemModel, success: ((PrivateBaseItemModel)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        let record = model.convertToAccountPassRecord()
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { records, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = records?.first else {
                    NotificationCenter.default.post(name: NSNotification.Name(kPostCloudKitErrorKey), object: error)
                    fail?(error)
                    return
                }
                
                var updateModel = firstRecord.convertToAccountModel()
                updateModel.isSyncCloud = true
                SandboxFileManager.shared.saveOrUpdateItemModel(updateModel)
                self.updatePasswordToExtension(updateModel)
                
                self.sharedDefault.set(Date().timeIntervalSince1970, forKey: 🔒)
                self.sharedDefault.synchronize()
                
                NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: updateModel, userInfo: nil)
                success?(updateModel)
            }
        }
        
        self.privateDatabase.add(operation)
    }
    
}
