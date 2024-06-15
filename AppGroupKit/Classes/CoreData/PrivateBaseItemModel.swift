//
//  PrivateBaseItemModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/24.
//

import HandyJSON
import SDWebImage
import AuthenticationServices
import CloudKit

public struct PrivateBaseItemModel: HandyJSON, Equatable {
    
    
    public init() {}
    
    public var recordType = AppRecordType.defaultBook
    
    public var storageType = StorageItemType.password
    
    public var isCollection: Bool = false
    
    public var recordId: String = ""
    
    public var userID: String?
    
    public var isSyncCloud: Bool = false
    
    public var customTitle: String?
    
    public var notes: String?
    
    var iconColorHex: String?
        
    public var assetIdArray: [String]?
    
    public var createDate: TimeInterval?
    
    public var modifyDate: TimeInterval?
    
    public var isSelect: Bool = false
    
    
    public var passwordModel: PrivateAccountModel?
    
//    public var photosModel: PrivatePhotosModel?
    
//    public var notesModel: PrivatePhotosModel?
    
//    public var contactModel: PrivateContactModel?
    

    public var tempAssetArray: [SingleFileModel]?
    
    
    public mutating func mapping(mapper: HelpingMapper) {
        mapper >>> self.tempAssetArray
        mapper >>> self.isSelect
    }
    
    public static func == (lhs: PrivateBaseItemModel, rhs: PrivateBaseItemModel) -> Bool {
        let isRecordId = lhs.recordId == rhs.recordId
        let isCustomTitle = lhs.customTitle == rhs.customTitle
        let isAccount = lhs.passwordModel?.accountName == rhs.passwordModel?.accountName
        
        let lhsPasswords = lhs.passwordModel?.passwords ?? []
        let rhsPasswords = rhs.passwordModel?.passwords ?? []
        let isPasswordCount = lhsPasswords.count == rhsPasswords.count
        let isPassword = lhsPasswords.elementsEqual(rhsPasswords) { $0.password == $1.password }
        
        let isWebsite = lhs.passwordModel?.websiteModel?.host == rhs.passwordModel?.websiteModel?.host
        let isNotes = lhs.notes == rhs.notes
        let isSyncCloud = lhs.isSyncCloud == rhs.isSyncCloud
        
        let lhsAssetIds = (lhs.tempAssetArray ?? []).map { $0.recordId }
        let rhsAssetIds = rhs.assetIdArray ?? []
        let isAttachment = lhsAssetIds == rhsAssetIds || (lhsAssetIds.isEmpty && rhsAssetIds.isEmpty)

        let isSame = isRecordId && isCustomTitle && isAccount && isPasswordCount && isPassword && isWebsite && isNotes && isSyncCloud && isAttachment
        return isSame
    }

    
    public func showSecondDesc() -> String? {
        var createDate: String?
        if let createTime = self.createDate?.rounded() {
            createDate = Date(timeIntervalSince1970: createTime).dateString(ofStyle: .medium)
        }
        
        if self.storageType == .password {
            return self.passwordModel?.accountName ?? createDate
        }else if self.storageType == .photoVault {
            if let assetIdArray = self.assetIdArray, assetIdArray.count > 0 {
                return String(format: "%@ files".localStr(), "\(assetIdArray.count)")
            }else{
                return createDate
            }
        }else if self.storageType == .secretNotes {
            return self.notes ?? createDate
        }
        else{
            return createDate
        }
    }
    
    public func createPasswordCredential() -> ASPasswordCredentialIdentity? {
        guard let webURL = self.passwordModel?.websiteModel?.dominUrlStr(), let accountName = self.passwordModel?.accountName else {
            return nil
        }
        
        let passwordCre = ASPasswordCredentialIdentity(serviceIdentifier: ASCredentialServiceIdentifier(identifier: webURL, type: .URL), user: accountName, recordIdentifier: self.recordId)
        return passwordCre
    }
}


extension PrivateBaseItemModel {
    
    public func searchMatcheItem(_ queryKey: String) -> Bool {
        let lowercasedQuery = queryKey.lowercased()
        
        if let customTitle = customTitle, customTitle.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        if let notes = notes, notes.lowercased().contains(lowercasedQuery) {
            return true
        }
        
        if let passwordModel = passwordModel {
            if let accountName = passwordModel.accountName, accountName.lowercased().contains(lowercasedQuery) {
                return true
            }
            
            if let websiteName = passwordModel.websiteModel?.webName, websiteName.lowercased().contains(lowercasedQuery) {
                return true
            }
            
            if let websiteUrl = passwordModel.websiteModel?.websiteUrl, websiteUrl.lowercased().contains(lowercasedQuery) {
                return true
            }
        }
        
        return false
    }
    
    public func loadCoverImage(imageSize: CGSize, completion:((UIImage?)->Void)? = nil) {
        if self.storageType == .password {
            let imgURL = URL(string: self.passwordModel?.websiteModel?.imageUrlStr() ?? "")
            SDWebImageManager.shared.loadImage(with: imgURL, progress: nil) { (image, data, error, cache, finish, url) in
                let newImage = image?.kaka_reSize(reSize: imageSize) ?? (self.firstString().image(withAttributes: [.font: UIFont.boldSystemFont(ofSize: imageSize.width * 0.6)], size: imageSize, backgroundColor: UIColor.rgb(123, 123, 129), textColor: UIColor.white))
                completion?(newImage)
            }
        }else if self.storageType == .photoVault {
            let newImage = self.storageType.systemIconImage()
            completion?(newImage)
            
        }else if self.storageType == .secretNotes {
            let newImage = self.storageType.systemIconImage()
            completion?(newImage)
        }else{
            let newImage = self.storageType.systemIconImage()
            completion?(newImage)
        }
        
    }
    
    public func fileAssetRecords() -> [CKRecord]? {
        guard let assetIdArray = self.assetIdArray, assetIdArray.count > 0 else {
            return nil
        }
        
        var recordArray = [CKRecord]()
        
        for subRecordID in assetIdArray {
            
            let subModel = SandboxFileManager.shared.readPassFileAsset(recordType: self.recordType, recordId: subRecordID)

            let fileRecord = CKRecord(recordType: CloudRecordType_PasswordFile, recordID: CKRecord.ID(recordName: subRecordID))
            var jsonStr = subModel?.toJSONString() ?? ""
            jsonStr = CryptoHelper.encryptAES(string: jsonStr, key: ...) ?? ""
            
            fileRecord.setObject(jsonStr.ocString, forKey: ...)
            if let assetModel = subModel?.assetModel {
                fileRecord.setObject(assetModel, forKey: ...)
            }
            
            recordArray.append(fileRecord)
        }
        
        return recordArray
    }
}
