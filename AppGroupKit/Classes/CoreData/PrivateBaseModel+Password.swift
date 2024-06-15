//
//  PrivateBaseItemModel+Password.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/24.
//

import Foundation
import CloudKit

extension PrivateBaseItemModel {
    
    public func isWeakPassword() -> Bool {
        
        guard let newPassword = self.passwordModel?.passwords?.first else { return false }
        
        let isBeyond16Len = newPassword.password.count >= 16
        
        if (!isBeyond16Len) {
            return true
        }
        
        
        let sixMonthsAgoDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        let createTimeDate = newPassword.createTime.formatDate()
        let dateResult = createTimeDate.compare(sixMonthsAgoDate)
        
        if dateResult == .orderedAscending {
            return true
        }
        
        
        let isStrongPass = newPassword.password.isStrongPassWord()
        if (!isStrongPass) {
            return true
        }
        
        return false
    }
    
    public func convertToAccountPassRecord() -> CKRecord {
        
        var record: CKRecord = CKRecord(recordType: self.recordType.rawValue, recordID: CKRecord.ID(recordName: self.recordId))
        
        var tempRecord = self
        tempRecord.recordId = record.recordID.recordName
        
        record.setObject(self.storageType.rawValue.ocString, forKey: ...)
                
        var jsonStr = tempRecord.toJSONString() ?? ""
        jsonStr = CryptoHelper.encryptAES(string: jsonStr, key: ...) ?? ""
        record.setObject(jsonStr.ocString, forKey: ...)
        
        return record
    }
    
    public func updateRecord(_ fetchRecord: CKRecord) -> CKRecord {
        let updateRecord = fetchRecord
        
        updateRecord.setObject(self.storageType.rawValue.ocString, forKey: ...)
        
        var jsonStr = self.toJSONString() ?? ""
        jsonStr = CryptoHelper.encryptAES(string: jsonStr, key: ...) ?? ""
        updateRecord.setObject(jsonStr.ocString, forKey: ...)
                
        return updateRecord
    }
        
    public func firstChar() -> String {
        guard let title = self.customTitle else { return "#" }
        
        let collator =  UILocalizedIndexedCollation.current()
        let titleIndex = collator.section(for: title, collationStringSelector: #selector(NSObject.description))
        
        let firstChar = collator.sectionTitles[titleIndex]
        
        return firstChar
    }
    
    public func firstString() -> String {
        guard let title = self.customTitle?.removeSpace(), title.count > 0 else { return "#" }
        if let firstChar = title.first {
            return String(firstChar).uppercased()
        }else{
            return "#"
        }
    }
}

extension CKRecord {
    
    public func convertToAccountModel() -> PrivateBaseItemModel {
        var jsonStr = (self.object(forKey: ...) as? String) ?? ""
        jsonStr = CryptoHelper.decryptAES(string: jsonStr, key: ...) ?? ""
        
        var model = PrivateBaseItemModel.deserialize(from: jsonStr) ?? PrivateBaseItemModel()
        model.customTitle = (model.customTitle == nil) ? model.passwordModel?.accountName : model.customTitle
        model.createDate = self.creationDate?.timeIntervalSince1970
        model.modifyDate = self.modificationDate?.timeIntervalSince1970
        return model
    }
}
