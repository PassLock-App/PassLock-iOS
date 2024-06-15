//
//  AppICloudManager+Website.swift
//  PassLock
//
//  Created by Melo on 2023/9/10.
//

import KakaFoundation
import CloudKit


extension AppICloudManager {
    public func saveWebsiteModel(_ model: WebsiteInfoModel, success: (([WebsiteInfoModel])->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        if 🔒 {
            var localArray = SandboxFileManager.shared.readPrivateWebsiteModel()
            
            if let index = localArray.firstIndex(where: { model.recordWebId == $0.recordWebId }) {
                localArray.remove(at: index)
                localArray.insert(model, at: 0)
                SandboxFileManager.shared.writePrivateWebsiteModel(model)
                success?(localArray)
            } else {
                localArray.insert(model, at: 0)
                SandboxFileManager.shared.writePrivateWebsiteModel(model)
                success?(localArray)
            }
            
            SandboxFileManager.shared.writePrivateWebsiteModel(model)
            return
        }
        
        let webRecord = model.convertCkRecord()
        
        let operation = CKModifyRecordsOperation(recordsToSave: [webRecord], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { records, recordIds, error in
            DispatchQueue.main.async {
                guard let firstRecord = records?.first else {
                    fail?(error)
                    return
                }
                
                let newModel = firstRecord.convertPrivateWebsite()
                var localArray = SandboxFileManager.shared.readPrivateWebsiteModel()
                
                if let index = localArray.firstIndex(where: { newModel.recordWebId == $0.recordWebId }) {
                    localArray.remove(at: index)
                    localArray.insert(newModel, at: 0)
                    SandboxFileManager.shared.writePrivateWebsiteModel(newModel)
                    success?(localArray)
                } else {
                    localArray.insert(newModel, at: 0)
                    SandboxFileManager.shared.writePrivateWebsiteModel(newModel)
                    success?(localArray)
                }
            }
        }
        
        self.privateDatabase.add(operation)
        
    }
    
    public func fetchRemoteIcon(webModel: WebsiteInfoModel, completion: ((WebsiteInfoModel)->Void)? = nil) {

        guard let host = webModel.host else {
            completion?(webModel.defaultModel())
            return
        }
        
        guard let hostUrl = URL(string: "http://favicongrabber.com/api/grab/\(host)") else {
            completion?(webModel.defaultModel())
            return
        }
        
        let headers = [
          "accept": "application/json"
        ]
        
        let request = NSMutableURLRequest(url: hostUrl,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion?(webModel.defaultModel())
                }
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
                
                guard let iconListModel = WebIconListModel.deserialize(from: jsonObject)else {
                    DispatchQueue.main.async {
                        completion?(webModel.defaultModel())
                    }
                    return
                }
                
                var model = webModel
                model.iconInfo = iconListModel
                completion?(model)
                
            } catch {
                DispatchQueue.main.async {
                    completion?(webModel.defaultModel())
                }
            }
            
        })
        
        dataTask.resume()
    }
    
    public func deleteWebsiteModel(webModel: WebsiteInfoModel, success: ((WebsiteInfoModel)->Void)? = nil, fail: ((Error?)->Void)? = nil) {
        
        if !webModel.isSyncCloud {
            SandboxFileManager.shared.deleteWebsiteModel(webModel)
            success?(webModel)
            return
        }
        
        let recordID = CKRecord.ID(recordName: webModel.recordWebId)
                
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordID])
        operation.modifyRecordsCompletionBlock = { records, ids, error in
            DispatchQueue.main.async {
                guard let recordIDs = ids?.first else {
                    fail?(error)
                    return
                }
                
                success?(webModel)
            }
        }
        
        privateDatabase.add(operation)
    }
    
    public func deleteAllWebsite(complection:(()->Void)? = nil) {
        
        let websites = SandboxFileManager.shared.readPrivateWebsiteModel()
        
        if websites.count == 0 {
            self.preloadRemoteWebsite { newWebsites in
                if (newWebsites.count == 0) {
                    complection?()
                    return
                }
                self.deleteAllWebsite(complection: complection)
            }
            return
        }
        
        let recordIDsToDelete = websites.map { CKRecord.ID(recordName: $0.recordWebId ?? "") }
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete)
        operation.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
            complection?()
        }
        
        privateDatabase.add(operation)
    }
    
}
