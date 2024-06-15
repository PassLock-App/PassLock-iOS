//
//  SandboxFileManager+Avatar.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/7/16.
//

import KakaFoundation
import CloudKit

extension SandboxFileManager {
    
    public func saveAvatarImageSanbox(userModel: 🔒, image: UIImage) -> CKAsset? {
        
        guard let remoteAvatar = userModel.remoteAvatar else { return nil }
        
        var accountFolderPath = basePublicFilePath + 🔒 + "/" + "UserConfig" + "/"
        
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
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                return nil
            }
            
            let fileName = remoteAvatar + ".jpg"
            var assetPath: URL!
            if #available(iOS 16.0, *) {
                assetPath = accountFolderURL.appending(path: fileName, directoryHint: .notDirectory)
            } else {
                assetPath = accountFolderURL.appendingPathComponent(fileName, isDirectory: false)
            }
            
            try? imageData.write(to: assetPath, options: .atomic)

            return CKAsset(fileURL: assetPath)
        
        } catch {
            return nil
        }
        
    }
    
    public func readRemoteAvatar(_ userModel: 🔒) -> UIImage? {
        
        guard let remoteAvatar = userModel.remoteAvatar else { return nil }

        var accountFolderPath = basePublicFilePath + 🔒+ "/" + "UserConfig" + "/"
        let fileName = remoteAvatar + ".jpg"
        
        accountFolderPath = accountFolderPath + fileName
        
        if FileManager.default.fileExists(atPath: accountFolderPath) {
            guard let imageData = FileManager.default.contents(atPath: accountFolderPath) else {
                return nil
            }
            
            return UIImage(data: imageData)
        } else {
            return nil
        }
        
    }
    
    public func deleteRemoteAvatar(_ userModel: 🔒) {
        
        guard let remoteAvatar = userModel.remoteAvatar else { return }

        var accountFolderPath = basePublicFilePath + 🔒 + "/" + "UserConfig" + "/"
        let fileName = remoteAvatar + ".jpg"
        
        accountFolderPath = accountFolderPath + fileName
        
        if FileManager.default.fileExists(atPath: accountFolderPath) {
            do {
                try FileManager.default.removeItem(atPath: accountFolderPath)
                let success = FileManager.default.isDeletableFile(atPath: accountFolderPath)
            } catch {
            }
        }
        
    }
    
}
