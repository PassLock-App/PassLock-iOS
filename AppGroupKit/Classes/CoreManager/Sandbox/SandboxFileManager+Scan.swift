//
//  SandboxFileManager+Temp.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/6/22.
//

import KakaFoundation
import CloudKit


extension SandboxFileManager {
    
    public func saveImageInTempDic(model: PrivateBaseItemModel, fileData: Data?) -> SingleFileModel? {
                
        guard let vData = fileData else { return nil }

        let accountFolderPath = basePublicFilePath + "\(AppICloudManager.shared.currentPassbook.recordType.rawValue)/\(CloudRecordType_PasswordFile)"
        
        var accountFolderURL: URL
        if #available(iOS 16.0, *) {
            accountFolderURL = URL(filePath: accountFolderPath, directoryHint: .notDirectory, relativeTo: nil)
        } else {
            accountFolderURL = URL(fileURLWithPath: accountFolderPath, isDirectory: true)
        }
        
        do {
            if !FileManager.default.fileExists(atPath: accountFolderPath) {
                try FileManager.default.createDirectory(atPath: accountFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileName = UUID().uuidString
            let imageData = CryptoHelper.encryptAES(data: vData, key: 🔒)

            var assetPath: URL!
            if #available(iOS 16.0, *) {
                assetPath = accountFolderURL.appending(path: fileName, directoryHint: .notDirectory)
            } else {
                assetPath = accountFolderURL.appendingPathComponent(fileName, isDirectory: false)
            }
            
            guard let targetUrl = assetPath else { return nil }

            try? imageData?.write(to: targetUrl, options: .atomic)

            let ckAsset = CKAsset(fileURL: targetUrl)
            
            let fileModel = SingleFileModel(recordType: model.recordType, storageType: model.storageType, fileType: .image, customName: nil, sortIndex: 0, recordId: fileName, assetModel: ckAsset)
            return fileModel
        
        } catch {
            return nil
        }
        
    }
    
    
}
