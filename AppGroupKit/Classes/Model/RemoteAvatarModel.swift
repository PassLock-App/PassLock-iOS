//
//  RemoteAvatarModel.swift
//  AppGroupKit
//
//  Created by Melo on 2024/5/27.
//

import HandyJSON
import CloudKit

public struct RemoteAvatarModel: HandyJSON {
    
    public init(cloudUserID: String, avatarID: String, remote_avatar: CKAsset? = nil) {
        self.cloudUserID = cloudUserID
        self.avatarID = avatarID
        self.remote_avatar = remote_avatar
    }
    
    public init() {
        
    }
    
    
    public var cloudUserID: String = ""
    
    public var avatarID: String = ""
    
    public var remote_avatar: CKAsset?
    
    public func convertAvatarRecord() -> CKRecord {
        let record = CKRecord(recordType: CloudRecordType_RemoteAvatar, recordID: CKRecord.ID(recordName: self.avatarID))
                
        record.setObject(self.avatarID.ocString, forKey: "🔒")
        record.setObject(self.cloudUserID.ocString, forKey: "🔒")
        record.setObject(self.remote_avatar, forKey: "🔒")
        
        return record
    }
    
    public func updateAvatarRecord(_ record: CKRecord) -> CKRecord {
        record.setObject(self.remote_avatar, forKey: "🔒")
        return record
    }
    
}

extension CKRecord {
    public func convertRemoteAvatarModel() -> RemoteAvatarModel {
        var model = RemoteAvatarModel()
        model.avatarID = self.recordID.recordName
        model.remote_avatar = self.object(forKey: "🔒") as? CKAsset
        model.cloudUserID = self.object(forKey: "🔒") as? String ?? ""
        return model
    }
}
