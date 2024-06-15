//
//  SingleFileModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/1.
//

import HandyJSON
import CloudKit
import KakaFoundation
import AppGroupKit

public enum PrivateFileType: Int, HandyJSONEnum {
    case image = 0
    case video = 1
    case pdf = 2
}

public struct SingleFileModel: HandyJSON, Equatable {
    
    public init() { }
    
    public init(recordType: AppRecordType, storageType: StorageItemType, fileType: PrivateFileType, customName: String?, sortIndex: Int, recordId: String, assetModel: CKAsset? = nil) {
        self.recordType = recordType
        self.storageType = storageType
        self.fileType = fileType
        self.customName = customName
        self.sortIndex = sortIndex
        self.recordId = recordId
        self.assetModel = assetModel
    }
    
    public var recordType: AppRecordType = .defaultBook
    
    public var storageType: StorageItemType = .password
    
    public var fileType: PrivateFileType = .image
    
    public var customName: String?
    
    public var sortIndex: Int = 0
    
    public var recordId: String = ""
    
    public var assetModel: CKAsset?
    
    public mutating func mapping(mapper: HelpingMapper) {
        mapper >>> self.assetModel
        
    }
    
    public func assetImage(_ aesKey: ...) -> UIImage? {
        if let fileData = self.assetModel?.originFileData(), let imageData = CryptoHelper.decryptAES(data: fileData, key: aesKey) {
            let thumbImage = UIImage(data: imageData)
            return thumbImage
        }
        
        return nil
    }
        
    public static func == (lhs: SingleFileModel, rhs: SingleFileModel) -> Bool {
        let isRecordTypeEqual = lhs.recordType == rhs.recordType
        let isStorageTypeEqual = lhs.storageType == rhs.storageType
        let isFileTypeEqual = lhs.fileType == rhs.fileType
        let isCustomNameEqual = lhs.customName == rhs.customName
        let isSortIndexEqual = lhs.sortIndex == rhs.sortIndex
        let isRecordIdEqual = lhs.recordId == rhs.recordId
        let isAssetModelEqual = compareCKAssets(lhs.assetModel, rhs.assetModel)

        let isSame = isRecordTypeEqual && isStorageTypeEqual && isFileTypeEqual && isCustomNameEqual && isSortIndexEqual && isRecordIdEqual && isAssetModelEqual
        
        return isSame
    }

    private static func compareCKAssets(_ lhs: CKAsset?, _ rhs: CKAsset?) -> Bool {
        guard let lhsURL = lhs?.fileURL, let rhsURL = rhs?.fileURL else {
            return lhs == nil && rhs == nil
        }

        do {
            let lhsFileSize = try lhsURL.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
            let rhsFileSize = try rhsURL.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
            return abs(lhsFileSize - rhsFileSize) <= 1024
        } catch {
            return false
        }
    }
    
    
}

extension CKRecord {
    public func convertFileAssetModel(_ aesPassKey: ...) -> SingleFileModel? {
        var jsonStr = self.object(forKey: ...) as? String
        jsonStr = CryptoHelper.decryptAES(string: jsonStr ?? "", key: aesPassKey) ?? ""

        var fileModel = SingleFileModel.deserialize(from: jsonStr)
        fileModel?.recordId = self.recordID.recordName
        fileModel?.assetModel = self.object(forKey: ...) as? CKAsset
        
        return fileModel
    }
    
}
