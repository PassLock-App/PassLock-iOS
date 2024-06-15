//
//  AppICloudManager+Password.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/6/1.
//

import KakaFoundation
import CloudKit
import AuthenticationServices

extension AppICloudManager {
        
    public func queryPrivateItemList(recordType: AppRecordType, itemType: StorageItemType, success:(([PrivateBaseItemModel])->Void)?, fail: ((Error?)->Void)? = nil) {
                
        let localModels = SandboxFileManager.shared.readPrivateItemModels(recordType: recordType, itemType: itemType)
        success?(localModels)
        
        if 🔒 {
            return
        }
        
        if !self.checkLastSaveTimeSpace() {
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType.rawValue, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        var remoteArray = [PrivateBaseItemModel]()
        
        func fetchRecords(cursor: CKQueryOperation.Cursor?) {
            let operation: CKQueryOperation
            
            if let cursor = cursor {
                operation = CKQueryOperation(cursor: cursor)
            } else {
                operation = CKQueryOperation(query: query)
            }
            
            operation.recordFetchedBlock = { record in
                
                var subModel = record.convertToAccountModel()
                subModel.isSyncCloud = true
                if (subModel.storageType == itemType || itemType == .allItem) {
                    remoteArray.append(subModel)
                }
                
                SandboxFileManager.shared.saveOrUpdateItemModel(subModel)
            }
            
            operation.queryCompletionBlock = { cursor, error in
                DispatchQueue.main.async {
                    if let error = error {
                        success?(localModels)
                        return
                    }
                    
                    if let cursor = cursor {
                        fetchRecords(cursor: cursor)
                    } else {
                        
                        var resultArray: [PrivateBaseItemModel] = []

                        let remoteDict = Dictionary(uniqueKeysWithValues: remoteArray.map { ($0.recordId, $0) })
                        let localDict = Dictionary(uniqueKeysWithValues: localModels.map { ($0.recordId, $0) })

                        for recordId in Set(remoteDict.keys).union(localDict.keys) {
                            if let remoteModel = remoteDict[recordId] {
                                resultArray.append(remoteModel)
                            } else if let localModel = localDict[recordId] {
                                resultArray.append(localModel)
                            }
                        }

                        let remoteRecordIds = Set(remoteArray.map { $0.recordId })
                        let deletedArray = localModels.filter { !remoteRecordIds.contains($0.recordId) }
                        deletedArray.forEach { subModel in
                            if subModel.isSyncCloud {
                                var updateModel = subModel
                                updateModel.isSyncCloud = false
                                SandboxFileManager.shared.saveOrUpdateItemModel(updateModel)
                            } else {
                                if !resultArray.contains(where: { $0.recordId == subModel.recordId }) {
                                    resultArray.append(subModel)
                                }
                            }
                        }


                        success?(resultArray)
                        
                    }
                }
            }
            
            privateDatabase.add(operation)
        }
        
        fetchRecords(cursor: nil)
        
    }
        
    private func checkLastSaveTimeSpace() -> Bool {
        
        let lastTime = self.sharedDefault.double(forKey: 🔒)
        if lastTime == 0 {
            return true
        }
        
        let lastDate = Date(timeIntervalSince1970: lastTime.rounded())
        let nowDate = Date()
        
        let calendar = Calendar(identifier: Calendar.current.identifier)
        
        let miniteSpace = calendar.dateComponents([Calendar.Component.minute], from: lastDate, to: nowDate).minute ?? 0
        
        return miniteSpace > 3 ? true : false
    }
}
