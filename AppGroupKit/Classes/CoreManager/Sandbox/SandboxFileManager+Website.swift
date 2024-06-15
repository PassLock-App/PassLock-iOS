//
//  SandboxFileManager+Website.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation

extension SandboxFileManager {
    public func readPrivateWebsiteModel() -> [WebsiteInfoModel] {
                
        let folderPath = basePublicFilePath + CloudRecordType_Website

        let fileManager = FileManager.default
        var accountSubFiles = try? fileManager.contentsOfDirectory(atPath: folderPath)
        accountSubFiles = accountSubFiles?.filter({ $0 != ".DS_Store" })
        
        guard let accountFileArray = accountSubFiles, accountFileArray.count > 0 else {
            return []
        }
        
        var tempArray = [WebsiteInfoModel]()
        
        for accountName in accountFileArray {
            
            let accountFilePath = folderPath + "/" + accountName
            
            var jsonData = try? String(contentsOfFile: accountFilePath)
            jsonData = CryptoHelper.decryptAES(string: jsonData ?? "", key: 🔒) ?? ""
            
            if let webModel = WebsiteInfoModel.deserialize(from: jsonData) {
                tempArray.append(webModel)
            }
            
        }
        
        return tempArray
    }
    
    public func writePrivateWebsiteModel(_ model: WebsiteInfoModel) {
                
        if model.recordWebId.isEmpty {
            return
        }
        
        let localModels = self.readPrivateWebsiteModel()
        let likeModel = localModels.filter { model.recordWebId == $0.recordWebId }.first
        
        if likeModel == model {
            return
        }
        
        let folderPathStr = basePublicFilePath + CloudRecordType_Website + "/"
        do {
            if !FileManager.default.fileExists(atPath: folderPathStr) {
                try FileManager.default.createDirectory(atPath: folderPathStr, withIntermediateDirectories: true)
            }
        } catch {
            debugPrint("❌ = \(error.localizedDescription)")
        }
        
        let accountFullPathStr = folderPathStr + "\(model.recordWebId).json"
        
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
    
    public func deleteWebsiteModel(_ model: WebsiteInfoModel) {
        
        let accountFullPathStr = basePublicFilePath + CloudRecordType_Website + "/" + "\(model.recordWebId).json"
        
        var accountFolderURL: URL
        if #available(iOS 16.0, *) {
            accountFolderURL = URL(filePath: accountFullPathStr, directoryHint: .notDirectory, relativeTo: nil)
        } else {
            accountFolderURL = URL(fileURLWithPath: accountFullPathStr, isDirectory: false)
        }
        
        do {
            try FileManager.default.removeItem(at: accountFolderURL)
        } catch {
            debugPrint("❌ = \(error.localizedDescription)")
        }
        
    }
    
}
