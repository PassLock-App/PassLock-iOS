//
//  PrivateAccountModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/1.
//

import KakaFoundation
import CloudKit
import HandyJSON
import KakaObjcKit


public struct PrivateAccountModel: HandyJSON {
    
    public init() { }
    
    public var accountName: String?
    
    public var passwords: [PasswordListModel]?
    
    public var websiteModel: WebsiteInfoModel?
    
}


public struct PasswordListModel: HandyJSON {
    
    public init() { }
    
    public init(passwordID: String, password: String, createTime: TimeInterval, deviceType: DeviceOSType) {
        self.passwordID = passwordID
        self.password = password
        self.createTime = createTime
        self.deviceType = deviceType
    }
    
    public var passwordID: String = ""
    
    public var password: String = ""
    
    public var createTime: TimeInterval = 0
    
    public var deviceType = DeviceOSType.iOS
    
    public func formatCreateDate() -> Date {

        let newTime = createTime.rounded()

        let date = Date(timeIntervalSince1970: newTime)

        return date
    }
    
    public func convertToPassRecord() -> CKRecord {
        
        var record = CKRecord(recordType: CloudRecordType_CopiedPasswords, recordID: CKRecord.ID(recordName: self.passwordID))
        
        var tempRecord = self
        tempRecord.passwordID = record.recordID.recordName
        
        // JSON
        var jsonStr = tempRecord.toJSONString() ?? ""
        jsonStr = CryptoHelper.encryptAES(string: jsonStr, key: ...) ?? ""
        record.setObject(jsonStr.ocString, forKey: ...)
        
        return record
    }
}

extension CKRecord {
   
    public func convertToPassModel() -> PasswordListModel {
        var jsonStr = (self.object(forKey: ...) as? String) ?? ""
        jsonStr = CryptoHelper.decryptAES(string: jsonStr, key: ...) ?? ""
        
        var model = PasswordListModel.deserialize(from: jsonStr) ?? PasswordListModel()
        model.passwordID = self.recordID.recordName
        return model
    }
}
