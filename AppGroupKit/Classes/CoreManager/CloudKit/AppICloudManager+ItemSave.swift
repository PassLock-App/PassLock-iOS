//
//  AppICloudManager+ItemSave.swift
//  AppGroupKit
//
//  Created by Melo on 2024/1/13.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    
    public func saveMultipleRecords(models: [PrivateBaseItemModel], success: (([PrivateBaseItemModel])->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        let saveGroup = DispatchGroup()
        var saveError: Error?
        var saveArray = [PrivateBaseItemModel]()
        
        for subModel in models {
            if subModel.isSyncCloud {
                
                var localModel = subModel
                localModel.isSyncCloud = false
                SandboxFileManager.shared.saveOrUpdateItemModel(localModel)
                
                guard let assetArray = subModel.fileAssetRecords(), assetArray.count > 0 else {
                    saveGroup.enter()
                    self.saveItemModel(model: subModel) { model in
                        saveArray.append(model)
                        saveGroup.leave()
                    } fail: { error in
                        saveError = error
                        saveGroup.leave()
                    }
                    continue
                }
                
                saveGroup.enter()
                let operation = CKModifyRecordsOperation(recordsToSave: assetArray, recordIDsToDelete: nil)
                operation.isAtomic = true
                operation.savePolicy = .changedKeys
                
                operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
                    guard let savedRecords = savedRecords else {
                        saveError = error
                        saveGroup.leave()
                        return
                    }
                    
                    localModel.isSyncCloud = true
                    localModel.assetIdArray = savedRecords.map({ $0.recordID.recordName })
                    self.saveItemModel(model: localModel) { model in
                        saveArray.append(model)
                        saveGroup.leave()
                    } fail: { error in
                        saveError = error
                        saveGroup.leave()
                        var tempModel = localModel
                        tempModel.isSyncCloud = false
                        NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: tempModel, userInfo: nil)
                    }

                }
                
                self.privateDatabase.add(operation)
                
            }else{
                saveGroup.enter()
                SandboxFileManager.shared.saveOrUpdateItemModel(subModel)
                saveArray.append(subModel)
                NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: subModel, userInfo: nil)
                saveGroup.leave()
            }
        }
        
        saveGroup.notify(queue: .main) {
            guard let error = saveError else {
                success?(saveArray)
                return
            }
            
            fail?(error)
        }
        
    }
    
    private func saveItemModel(model: PrivateBaseItemModel, success: ((PrivateBaseItemModel)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: [model.convertToAccountPassRecord()], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = savedRecords?.first else {
                    fail?(error)
                    NotificationCenter.default.post(name: NSNotification.Name(kPostCloudKitErrorKey), object: error)
                    return
                }
                
                var updateModel = model
                updateModel.isSyncCloud = true
                updateModel.modifyDate = firstRecord.modificationDate?.timeIntervalSince1970
                updateModel.createDate = firstRecord.creationDate?.timeIntervalSince1970
                SandboxFileManager.shared.saveOrUpdateItemModel(updateModel)
                self.addPasswordToExtension(updateModel)
                
                self.sharedDefault.set(Date().timeIntervalSince1970, forKey: 🔒)
                self.sharedDefault.synchronize()
                
                NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: updateModel, userInfo: nil)
                success?(updateModel)
            }
        }
        
        self.privateDatabase.add(operation)
        
    }
    
}
