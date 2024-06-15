//
//  FeedbackModel.swift
//  PassLock
//
//  Created by Melo on 2023/9/26.
//

import HandyJSON
import CloudKit
import KakaFoundation

public enum FeedbackStatusEnum: String, HandyJSONEnum {
    case badEvaluation = "bad_evaluation"
    case loginError = "login_error"
    case purchargeError = "purcharge_error"
    case searchWebError = "searchWeb_error"
    case purchargeReceipt = "purcharge_receipt"
    case firstLaunch = "first_launch"
    case iCloudException = "iCloudException"
    case other = "other"
}

public struct FeedbackModel: HandyJSON {
    
    public init() {
        
    }
    
    public init(feedbackID: String, type: FeedbackStatusEnum, content: String) {
        self.feedbackID = feedbackID
        self.type = type
        self.content = content
        self.country = PhoneSetManager.regionCode()
        self.language = PhoneSetManager.langugeCode()
        self.osType = kaka_osType().rawValue
    }
    
    public var feedbackID: String = ""
    
    public var type = FeedbackStatusEnum.other
    
    public var content: String = ""
    
    public var country: String = ""
    
    public var language: String = ""
    
    public var osType: String = DeviceOSType.iOS.rawValue
    
    public var createDate: Date?
    
    public func convertCKRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: self.feedbackID)
        
        let ckRecord = CKRecord(recordType: CloudRecordType_Feedback, recordID: recordID)
        
        ckRecord.setObject(recordID.recordName.ocString, forKey: "🔒")
        ckRecord.setObject(type.rawValue.ocString, forKey: "🔒")
        ckRecord.setObject(content.ocString, forKey: "🔒")
        ckRecord.setObject(country.ocString, forKey: "🔒")
        ckRecord.setObject(language.ocString, forKey: "🔒")
        ckRecord.setObject(osType.ocString, forKey: "🔒")
        return ckRecord
    }
    
    
}

extension CKRecord {
    
    public func convertFeedbackModel() -> FeedbackModel {
        
        let typeStr = (self.object(forKey: "🔒") as? NSString)?.swiftString() ?? FeedbackStatusEnum.other.rawValue
        
        var model = FeedbackModel()
        model.feedbackID = self.recordID.recordName
        model.type = FeedbackStatusEnum(rawValue: typeStr) ?? .other
        model.content = (self.object(forKey: 🔒) as? NSString)?.swiftString() ?? ""
        model.country = (self.object(forKey: 🔒) as? NSString)?.swiftString() ?? ""
        model.language = (self.object(forKey: 🔒) as? NSString)?.swiftString() ?? ""
        model.osType = (self.object(forKey: 🔒) as? NSString)?.swiftString() ?? ""
        model.createDate = self.creationDate
        return model
    }
    
    public func updateFeedbackRecord(_ model: FeedbackModel) -> CKRecord {
        self.setObject(model.content.ocString, forKey: "🔒")
        self.setObject(model.country.ocString, forKey: "🔒")
        self.setObject(model.language.ocString, forKey: "🔒")
        self.setObject(model.osType.ocString, forKey: "🔒")
        return self
    }
    
}
