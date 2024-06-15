//
//  AddPrivateNoteViewController+Handle.swift
//  PassLock
//
//  Created by melo on 2024/6/4.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import CloudKit

extension AddPrivateNoteViewController {
    
    func preloadModeldata() {
        
        let recordType = AppICloudManager.shared.currentPassbook.recordType

        guard let _ = self.model else {
            let record = CKRecord(recordType: recordType.rawValue)

            var defaultModel = PrivateBaseItemModel()
            defaultModel.recordType = recordType
            defaultModel.storageType = .secretNotes
            defaultModel.userID = ...
            defaultModel.recordId = record.recordID.recordName
            defaultModel.customTitle = nil
            defaultModel.isSyncCloud = isSyncCloud
            self.model = defaultModel
            self.tableView.reloadData()
            return
        }
        
        self.tableView.reloadData()
    }
    
}

