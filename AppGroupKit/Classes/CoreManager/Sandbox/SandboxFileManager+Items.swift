//
//  SandboxFileManager+Password.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/8/6.
//

import KakaFoundation
import KakaObjcKit
import HandyJSON
import CloudKit


extension SandboxFileManager {
    public func saveOrUpdateItemModel(_ model: PrivateBaseItemModel) {
                
        if model.recordId.isEmpty {
            return
        }
        
        let localModels = self.readPrivateItemModels(recordType: AppICloudManager.shared.currentPassbook.recordType, itemType: .allItem) ?? []
        let likeModel = localModels.filter { model.recordId == $0.recordId }.first
        
        if likeModel == model {
            return
        }
        
        let folderPathStr = basePublicFilePath + "\(model.recordType.rawValue)" + "/"
        do {
            if !FileManager.default.fileExists(atPath: folderPathStr) {
                try FileManager.default.createDirectory(atPath: folderPathStr, withIntermediateDirectories: true)
            }
        } catch {
        }
        
        let accountFullPathStr = folderPathStr + "\(model.recordId).json"
        
        var accountFolderURL: URL
        if #available(iOS 16.0, *) {
            accountFolderURL = URL(filePath: accountFullPathStr, directoryHint: .notDirectory, relativeTo: nil)
        } else {
            accountFolderURL = URL(fileURLWithPath: accountFullPathStr, isDirectory: true)
        }
                        
        do {
            
            let jsonData = CryptoHelper.encryptAES(string: model.toJSONString() ?? "", key: 🔒)
            try jsonData?.write(to: accountFolderURL, atomically: true, encoding: .utf8)
        } catch {
        }
        
    }
    
    public func readPrivateItemModels(recordType: AppRecordType, itemType: StorageItemType) -> [PrivateBaseItemModel] {
                
        
        let folderPath = basePublicFilePath + recordType.rawValue

        let fileManager = FileManager.default
        var accountSubFiles = try? fileManager.contentsOfDirectory(atPath: folderPath)
        accountSubFiles = accountSubFiles?.filter({ $0 != ".DS_Store" })
        accountSubFiles = accountSubFiles?.filter({ $0 != CloudRecordType_PasswordFile })
        
        guard let accountFileArray = accountSubFiles, accountFileArray.count > 0 else {
            return []
        }
        
        var tempArray = [PrivateBaseItemModel]()
        let aesKey = 🔒
        
        for accountName in accountFileArray {
            
            let accountFilePath = folderPath + "/" + accountName
            
            var jsonData = try? String(contentsOfFile: accountFilePath)
            jsonData = CryptoHelper.decryptAES(string: jsonData ?? "", key: aesKey) ?? ""
            
            let model = PrivateBaseItemModel.deserialize(from: jsonData)
            if let vModel = model {
                if (vModel.storageType == itemType || itemType == .allItem) {
                    tempArray.append(vModel)
                }
            }
            
        }
        
        return tempArray
    }

    
    public func deletePrivateItemModel(_ model: PrivateBaseItemModel, isDeleteAsset: Bool) {
                        
        let accountFullPathStr = basePublicFilePath + "\(model.recordType.rawValue)" + "/" + "\(model.recordId).json"
        
        var accountFolderURL: URL
        if #available(iOS 16.0, *) {
            accountFolderURL = URL(filePath: accountFullPathStr, directoryHint: .notDirectory, relativeTo: nil)
        } else {
            accountFolderURL = URL(fileURLWithPath: accountFullPathStr, isDirectory: false)
        }

        do {
            try FileManager.default.removeItem(at: accountFolderURL)
        } catch {
        }
        
        if !isDeleteAsset { return }
        
        guard let assetArray = model.assetIdArray, assetArray.count > 0 else { return }
        
        for subPath in assetArray {
            let assetPath = self.basePublicFilePath + model.recordType.rawValue + "/" + CloudRecordType_PasswordFile + "/" + subPath
            
            var destinationURL: URL!
            if #available(iOS 16.0, *) {
                destinationURL = URL(filePath: assetPath)
            } else {
                destinationURL = URL(fileURLWithPath: assetPath)
            }
            
            do {
                try FileManager.default.removeItem(at: destinationURL)
            } catch {
            }
        }
        
    }
    
}
