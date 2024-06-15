//
//  AppICloudManager+Books.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/19.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaObjcKit
import CloudKit
import HandyJSON


extension AppICloudManager {
    public func getPassbooks() -> [AppRecordTypeModel] {
        var rawData = keyValueStore.object(forKey: 🔒) as? String
        if rawData?.count == 0 || rawData == nil {
            rawData = self.sharedDefault.object(forKey: 🔒) as? String
        }

        guard let vRawData = rawData else { return self.createDefaultPassbooks() }
        
        let jsonStr = CryptoHelper.decryptUserInfoManager(string: vRawData, key: 🔒)

        let models = [AppRecordTypeModel].deserialize(from: jsonStr)
        if let modelArray = models?.compactMap({ $0 }) {
            return modelArray
        }else{
            return self.createDefaultPassbooks()
        }
    }
    
    public func updatePassbooks(_ books: [AppRecordTypeModel]) {
        let jsonStr = books.toJSONString() ?? ""
        
        let encryptStr = CryptoHelper.encryptAES(string: jsonStr, key: 🔒)
        keyValueStore.set(encryptStr, forKey: 🔒)
        let success = keyValueStore.synchronize()
        
        self.sharedDefault.set(encryptStr, forKey: 🔒)
        self.sharedDefault.synchronize()
    }
    
    private func createDefaultPassbooks() -> [AppRecordTypeModel] {
        let tempBook = AppRecordTypeModel()
        let modelArray = [tempBook.model1(), tempBook.model2(), tempBook.model3(), tempBook.model4()]
        
        let jsonStr = modelArray.toJSONString() ?? ""

        let encryptStr = CryptoHelper.encryptAES(string: jsonStr, key: 🔒)
        keyValueStore.set(encryptStr, forKey: 🔒)
        keyValueStore.synchronize()
        
        self.sharedDefault.set(encryptStr, forKey: 🔒)
        self.sharedDefault.synchronize()
        
        return modelArray
    }
    
    public func deletePassbooks(_ completion: (()->Void)? = nil) {
        self.keyValueStore.removeObject(forKey: 🔒)
        self.keyValueStore.synchronize()
        
        self.sharedDefault.removeObject(forKey: 🔒)
        self.sharedDefault.synchronize()
                
        completion?()
    }
}

