//
//  SandboxFileManager.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/6/18.
//

import KakaFoundation
import KakaObjcKit
import HandyJSON
import CloudKit

public class SandboxFileManager {
    
    public static let shared = SandboxFileManager()
    
    public init() {
        self.basePublicFilePath = self.getBaseFilePath()
    }
    
    public var basePublicFilePath: String!
    
    private func getBaseFilePath() -> String {
        
        if #available(iOSApplicationExtension 16.0, *) {
            guard let shareGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)?.path(percentEncoded: false) else {
                let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path(percentEncoded: false)
                return documentUrl
            }
            
            return shareGroupUrl
        } else {
            guard let shareGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)?.path else {
                let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
                return documentUrl + "/"
            }
            
            return shareGroupUrl + "/"
        }
    }
    
    lazy var fileRecordArray: [CKRecord] = {
        return [CKRecord]()
    }()
    
}
