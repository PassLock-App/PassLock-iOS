//
//  SandboxFileManager+Copied.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit

extension SandboxFileManager {
    public func readPasswordListModel() -> [PasswordListModel] {
                
        let folderPath = basePublicFilePath + CloudRecordType_CopiedPasswords

        let fileManager = FileManager.default
        var accountSubFiles = try? fileManager.contentsOfDirectory(atPath: folderPath)
        accountSubFiles = accountSubFiles?.filter({ $0 != ".DS_Store" })
        
        guard let accountFileArray = accountSubFiles, accountFileArray.count > 0 else {
            return []
        }
        
        var tempArray = [PasswordListModel]()
        
        for accountName in accountFileArray {
            
            let accountFilePath = folderPath + "/" + accountName
            
            var jsonData = try? String(contentsOfFile: accountFilePath)
            jsonData = CryptoHelper.decryptAES(string: jsonData ?? "", key: ) ?? ""
            
            if let webModel = PasswordListModel.deserialize(from: jsonData) {
                tempArray.append(webModel)
            }
            
        }
        
        let sortArray = tempArray.sorted { model1, model2 in
            return model1.formatCreateDate().compare(model2.formatCreateDate()) == .orderedDescending
        }
        
        return sortArray
    }
    
    public func writePasswordListModel(_ model: PasswordListModel) {
                
        if model.passwordID.isEmpty {
            return
        }
        
        let folderPathStr = basePublicFilePath + CloudRecordType_CopiedPasswords + "/"
        do {
            if !FileManager.default.fileExists(atPath: folderPathStr) {
                try FileManager.default.createDirectory(atPath: folderPathStr, withIntermediateDirectories: true)
            }
        } catch {
            debugPrint("❌ = \(error.localizedDescription)")
        }
        
        let accountFullPathStr = folderPathStr + "\(model.passwordID).json"
        
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
    
}
