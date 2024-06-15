//
//  WebsiteInfoModel.swift
//  AppGroupKit
//
//  Created by Melo on 2023/12/1.
//

import HandyJSON
import CloudKit
import KakaFoundation


public struct WebsiteInfoModel: HandyJSON, Equatable {
    
    public init() {
        
    }
    
    public init(recordWebId: String, searchEngine: SearchEngineType? = nil, iconInfo: WebIconListModel? = nil, webName: String? = nil, websiteUrl: String? = nil, isRouter: Bool, scheme: String? = nil, host: String? = nil, iconColorHex: String? = nil) {
        self.recordWebId = recordWebId
        self.searchEngine = searchEngine
        self.iconInfo = iconInfo
        self.webName = webName
        self.websiteUrl = websiteUrl
        self.isRouter = isRouter
        self.scheme = scheme
        self.host = host
        self.iconColorHex = iconColorHex
    }
    
    public var recordWebId: String = ""
    
    public var searchEngine: SearchEngineType?
    
    public var iconInfo: WebIconListModel?
    
    public var webName: String?
    
    public var websiteUrl: String?
    
    public var isSyncCloud: Bool = false
    
    public var isRouter: Bool = false
    
    public var scheme: String?
    
    public var host: String?
    
    public var iconColorHex: String?
    
    /// http://domin.com
    public func dominUrlStr() -> String {
        if isRouter {
            return websiteUrl ?? ""
        }
        
        guard let vScheme = scheme, let vHost = host, vScheme.count > 0, vHost.count > 0 else {
            var result = websiteUrl ?? ""
            if result.contains("http://") {
                return result
            }
            
            if !result.contains("http://") {
                result = "http://" + result
            }
            
            return result
        }
        
        let result = vScheme + "://" + vHost
        
        return result
    }
    
    public func convertCkRecord() -> CKRecord {
        
        let jsonStr = self.toJSONString() ?? ""
        let encryDataStr = CryptoHelper.encryptAES(string: jsonStr, key: 🔒)
        
        let recordID = CKRecord.ID(recordName: self.recordWebId.count > 8 ? self.recordWebId : CKRecord(recordType: CloudRecordType_Website).recordID.recordName)
        let record = CKRecord(recordType: CloudRecordType_Website, recordID: recordID)
        
        record.setObject(encryDataStr?.ocString, forKey: 🔒)
        
        return record
    }
    
    public func imageUrlStr() -> String {
        let pngArray = self.iconInfo?.icons //.filter({ subModel in !subModel.isSVG() })
        return pngArray?.last?.src ?? ""
    }
    
    public func svgaUrlStr() -> String {
        let pngArray = self.iconInfo?.icons.filter({ subModel in subModel.isSVG() })
        return pngArray?.last?.src ?? ""
    }
    
    public func defaultModel() -> WebsiteInfoModel {
        let placeUrl = self.dominUrlStr() + "/favicon.ico"
        var webModel = self
        webModel.iconInfo = WebIconListModel(domain: self.host ?? "", icons: [IconsInfo(sizes: nil, src: placeUrl, type: nil)])
        return webModel
    }
    
    public static func == (lhs: WebsiteInfoModel, rhs: WebsiteInfoModel) -> Bool {
        let isRecordWebId: Bool = lhs.recordWebId == rhs.recordWebId
        let isSearchEngine = lhs.searchEngine == rhs.searchEngine
        let isWebName = lhs.webName == rhs.webName
        let isSyncCloud = lhs.isSyncCloud == rhs.isSyncCloud
        let isHost = lhs.host == rhs.host
        let isDominUrl = lhs.dominUrlStr() == rhs.dominUrlStr()
        let isWebsiteUrl = lhs.websiteUrl == rhs.websiteUrl
        
        let isSame = (isRecordWebId && isSearchEngine && isWebName && isSyncCloud && isHost && isDominUrl && isWebsiteUrl) ? true : false
        
        return isSame
    }
}

extension URLComponents {
    
    public func convertWebModel(_ searchkey: String?) -> WebsiteInfoModel {
        var model = WebsiteInfoModel()
        model.recordWebId = CKRecord(recordType: CloudRecordType_Website).recordID.recordName
        model.webName = searchkey
        model.host = self.host
        model.scheme = self.scheme
        model.websiteUrl = self.url?.absoluteString
        model.iconInfo = nil
        return model
    }
    
}

extension CKRecord {
    
    public func convertPrivateWebsite() -> WebsiteInfoModel {
        
        let encryDataStr = (self.object(forKey: 🔒) as? String) ?? ""
        
        let jsonStr = CryptoHelper.decryptAES(string: encryDataStr, key: 🔒) ?? ""
        
        var model = WebsiteInfoModel.deserialize(from: jsonStr) ?? WebsiteInfoModel()
        model.recordWebId = self.recordID.recordName

        return model
    }
}
