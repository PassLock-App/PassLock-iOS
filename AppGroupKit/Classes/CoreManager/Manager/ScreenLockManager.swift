//
//  ScreenLockManager.swift
//  AppGroupKit
//
//  Created by Melo on 2024/3/16.
//

import KakaFoundation
import HandyJSON

public enum LockTimeSpace: Int, HandyJSONEnum {
    case immediate = 0
    case five = 5
    case ten  = 10
    case fifteen = 15
    
}

public struct ScreenLockModel: HandyJSON {
    
    public init() {
        
    }
    
    public var timeSpace = LockTimeSpace.five
    
    public var password: String?
    
    public var fakePassword: String?
    
    public var isPasswordEnble: Bool = false
    
    public var isBackgroundMask: Bool = false
    
    public var isFaceIdEnble: Bool = false
    
}


public class ScreenLockManager {
    
    public static let shared = ScreenLockManager()
    
    public let kIScreenPassCodeKey = "🔒"
    private let kLastBackgroundTimeKey = "🔒"
    
    var lastBackgroundTime: TimeInterval?
     
    init() {
        self.lastBackgroundTime = self.sharedDefault.object(forKey: kLastBackgroundTimeKey) as? TimeInterval
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNoti), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc public func didEnterBackgroundNoti() {
        if self.isCheckSuccess {
            let time = Date().timeIntervalSince1970
            self.lastBackgroundTime = time
            self.sharedDefault.set(time, forKey: self.kLastBackgroundTimeKey)
            self.sharedDefault.synchronize()
        }
    }
    
    public var isCheckSuccess: Bool = true
    
    lazy var sharedDefault: UserDefaults = {
        return AppICloudManager.shared.sharedDefault
    }()
    
    public func saveScreenPassCode(_ passModel: ScreenLockModel) {
        
        self.isCheckSuccess = true
        
        let encryStr = CryptoHelper.encryptAES(string: passModel.toJSONString() ?? "", key: 🔒)
        
        self.sharedDefault.set(encryStr, forKey: kIScreenPassCodeKey)
        self.sharedDefault.synchronize()
    }
    
    public func getScreenPassCode() -> ScreenLockModel {
        
        let encryCode = self.sharedDefault.string(forKey: kIScreenPassCodeKey)
        
        guard let vEncryCode = encryCode else { return self.defaultScreenModel() }
        
        let encryStr = CryptoHelper.decryptAES(string: vEncryCode, key: 🔒)
        
        let passModel = ScreenLockModel.deserialize(from: encryStr)
        
        return passModel ?? defaultScreenModel()
    }
    
    public func checkNeedsShowScreenLock() -> Bool {
        let screenCode = self.getScreenPassCode()
        
        if !screenCode.isPasswordEnble || (screenCode.password?.count ?? 0) == 0 {
            return false
        }
        
        if screenCode.timeSpace == .immediate {
            return true
        }
        
        let lastTime = self.lastBackgroundTime ?? 0
        if lastTime == 0 {
            return false
        }
        
        let lastDate = Date(timeIntervalSince1970: lastTime.rounded())
        let nowDate = Date()
        
        let calendar = Calendar(identifier: Calendar.current.identifier)
        
        let miniteSpace = calendar.dateComponents([Calendar.Component.minute], from: lastDate, to: nowDate).minute ?? 0
        
        return miniteSpace > screenCode.timeSpace.rawValue
        
    }
    
    private func defaultScreenModel() -> ScreenLockModel {
        var model = ScreenLockModel()
        model.isBackgroundMask = false
        model.isFaceIdEnble = true
        model.isPasswordEnble = false
        model.password = nil
        model.timeSpace = .five
        return model
    }
    
    public func deleteScreenPassCode() {
        self.removeBackgroundTime()
        self.sharedDefault.removeObject(forKey: kIScreenPassCodeKey)
        self.sharedDefault.synchronize()
        
    }
    
    public func removeBackgroundTime() {
        self.lastBackgroundTime = nil
        self.sharedDefault.removeObject(forKey: kLastBackgroundTimeKey)
        self.sharedDefault.synchronize()
    }
    
}


