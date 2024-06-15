//
//  CloudSyncManager.swift
//  AppGroupKit
//
//  Created by Melo on 2024/6/8.
//

import HandyJSON

public struct CloudSyncModel: HandyJSON {
    
    public init() {
        
    }
    
    public init(isCompressImage: Bool, isAutoDeleteAssets: Bool, isAutoSyncCloud: Bool) {
        self.isCompressImage = isCompressImage
        self.isAutoDeleteAssets = isAutoDeleteAssets
        self.isAutoSyncCloud = isAutoSyncCloud
    }
    
    public var isCompressImage: Bool = false
    
    public var isAutoDeleteAssets: Bool = false
    
    public var isAutoSyncCloud: Bool = false
    
}

public class CloudSyncManager {
    public static let shared = CloudSyncManager()
    
    public func readSyncConfig() -> CloudSyncModel {
        let encryStr = AppICloudManager.shared.sharedDefault.string(forKey: "🔒")
        let jsonStr = CryptoHelper.decryptAES(string: encryStr ?? "", key: 🔒)
        let model = CloudSyncModel.deserialize(from: jsonStr)
        
        return model ?? CloudSyncModel(isCompressImage: false, isAutoDeleteAssets: false, isAutoSyncCloud: false)
    }
    
    public func update(_ model: CloudSyncModel) {
        let jsonStr = model.toJSONString() ?? ""
        let encryStr = CryptoHelper.encryptAES(string: jsonStr, key: 🔒)
        
        AppICloudManager.shared.sharedDefault.set(encryStr, forKey: "🔒")
        AppICloudManager.shared.sharedDefault.synchronize()
        
    }
    
}

