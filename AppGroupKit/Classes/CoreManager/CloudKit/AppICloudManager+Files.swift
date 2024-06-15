//
//  AppICloudManager+Files.swift
//  AppGroupKit
//
//  Created by Melo on 2024/1/11.
//

import KakaFoundation
import CloudKit

extension AppICloudManager {
    
        
    public func queryPassFileModel(recordID: String, success: ((SingleFileModel)->Void)? = nil, fail: ((String?)->Void)?) {
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
        
        let predicate = NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: recordID))
        let query = CKQuery(recordType: CloudRecordType_PasswordFile, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]

        self.privateDatabase.perform(query, inZoneWith: .default) { (records, error) in
            DispatchQueue.main.async {
                guard let firstRecord = records?.first else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                let aesKey = 🔒
                if let fileModel = firstRecord.convertFileAssetModel(aesKey) {
                    SandboxFileManager.shared.writePassFileAsset(fileModel)
                    success?(fileModel)
                }else{
                    fail?(nil)
                }
            }
        }
        
    }
    
}
