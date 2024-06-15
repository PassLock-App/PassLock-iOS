//
//  SandboxFileManager+Files.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/9.
//

import KakaFoundation
import CloudKit

extension SandboxFileManager {
    
    public func writePassFileAsset(_ fileModel: SingleFileModel) {

        let folderPath = basePublicFilePath + "\(fileModel.recordType.rawValue)/\(CloudRecordType_PasswordFile)"
        
        do {
            if !FileManager.default.fileExists(atPath: folderPath) {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true)
            }
        } catch {
            debugPrint("❌ = \(error.localizedDescription)")
        }
        
        let localModels = self.readPrivateFileModels(recordType: fileModel.recordType) ?? []
        let likeModel = localModels.filter { fileModel.recordId == $0.recordId }.first
        
        if likeModel == fileModel {
            return
        }
        
        if let assetData = fileModel.assetModel?.originFileData() {
            do {
                let allPath = folderPath + "/" + fileModel.recordId
                var destinationURL: URL!
                if #available(iOS 16.0, *) {
                    destinationURL = URL(filePath: allPath)
                } else {
                    destinationURL = URL(fileURLWithPath: allPath)
                }
                try assetData.write(to: destinationURL)
            } catch {
                print("❌ = \(error.localizedDescription)")
            }
        }
        
    }
    
    public func readPrivateFileModels(recordType: AppRecordType) -> [SingleFileModel] {
                
        let folderPath = basePublicFilePath + recordType.rawValue + "/" + CloudRecordType_PasswordFile

        let fileManager = FileManager.default
        var accountSubFiles = try? fileManager.contentsOfDirectory(atPath: folderPath)
        accountSubFiles = accountSubFiles?.filter({ $0 != ".DS_Store" })
        
        guard let accountFileArray = accountSubFiles, accountFileArray.count > 0 else {
            return []
        }
        
        var tempArray = [SingleFileModel]()
        let aesKey = 🔒
        
        for accountName in accountFileArray {
            
            let accountFilePath = folderPath + "/" + accountName
            
            var model = SingleFileModel()
            model.recordId = accountName
            model.assetModel = CKAsset(fileURL: URL(fileURLWithPath: folderPath + "/" + accountName))
            
            tempArray.append(model)
        }
        
        return tempArray
    }
    
    public func deleteSingleFile(model: SingleFileModel) {
                
        let assetPath = self.basePublicFilePath + model.recordType.rawValue + "/" + CloudRecordType_PasswordFile + "/" + model.recordId
        
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
    
    public func readPassFileAsset(recordType: AppRecordType, recordId: String) -> SingleFileModel? {

        let folderPath = basePublicFilePath + "\(recordType.rawValue)/\(CloudRecordType_PasswordFile)"
        
        let fileManager = FileManager.default
        var accountSubFiles = try? fileManager.contentsOfDirectory(atPath: folderPath)
        accountSubFiles = accountSubFiles?.filter({ $0 != ".DS_Store" })

        guard let accountFiles = accountSubFiles, accountFiles.count > 0 else {
            return nil
        }
        
        var model: SingleFileModel?
        accountFiles.forEach {
            if (recordId == $0) {
                model = SingleFileModel()
                model?.recordId = $0
                model?.assetModel = CKAsset(fileURL: URL(fileURLWithPath: folderPath + "/" + $0))
            }
        }
        
        return model
    }
    
}
