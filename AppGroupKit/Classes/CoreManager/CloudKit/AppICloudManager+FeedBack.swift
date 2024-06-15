//
//  AppICloudManager+FeedBack.swift
//  PassLock
//
//  Created by Melo on 2023/9/26.
//

import Foundation
import CloudKit

extension AppICloudManager {
    
    public func addNewFeedBack(model: FeedbackModel, success: (()->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: [model.convertCKRecord()], recordIDsToDelete: nil)
        operation.isAtomic = true
        operation.savePolicy = .changedKeys
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let savedRecords = savedRecords, savedRecords.count > 0 else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                success?()
            }
        }
        
        self.publicDatabase.add(operation)
        
    }
    
    public func getFeedbackList(cursor: CKQueryOperation.Cursor?, successBlock: (([FeedbackModel], CKQueryOperation.Cursor?)->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        let sortDescriptor = NSSortDescriptor(key: CKRecord.SystemFieldKey.creationDate, ascending: false)
        sortDescriptor.allowEvaluation()
                
        var feedArray = [FeedbackModel]()
        
        let operation: CKQueryOperation
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: CloudRecordType_Feedback, predicate: predicate)
            query.sortDescriptors = [sortDescriptor]
            operation = CKQueryOperation(query: query)
        }
        
        operation.recordFetchedBlock = { record in
            feedArray.append(record.convertFeedbackModel())
        }
        
        operation.queryCompletionBlock = { cursor, error in
            if let error = error {
                DispatchQueue.main.async {
                    fail?(error.localizedDescription)
                }
                return
            }
                        
            DispatchQueue.main.async {
                successBlock?(feedArray, cursor)
            }
        }
        
        publicDatabase.add(operation)
    }
    
    public func deleteFeedBack(model: FeedbackModel, success: (()->Void)? = nil, fail: ((String?)->Void)? = nil) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [CKRecord.ID(recordName: model.feedbackID)])
        operation.isAtomic = true
        
        operation.modifyRecordsCompletionBlock = { savedRecords, recordIds, error in
            DispatchQueue.main.async {
                guard let recordIds = recordIds, recordIds.count > 0 else {
                    fail?(error?.localizedDescription)
                    return
                }
                
                success?()
            }
        }
        
        self.publicDatabase.add(operation)
        
    }
    
}

