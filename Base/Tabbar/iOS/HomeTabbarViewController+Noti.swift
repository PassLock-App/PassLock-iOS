//
//  HomeTabbarViewController+Noti.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import MBProgressHUD
import KakaUIKit
import CloudKit
import AppGroupKit
import Toast_Swift

extension HomeTabbarViewController {
    func addObserviseNoti() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNoti), name: UIApplication.willEnterForegroundNotification, object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceChanged), name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidRefundChanged), name: NSNotification.Name(kUserDidRefundMoneyKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloudKitError(_:)), name: Notification.Name(kPostCloudKitErrorKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAccountCanceledTips), name: Notification.Name(kUserDidCancelAccountKey), object: nil)
                                
    }
    
    @objc func userDidRefundChanged() {
                
        let recordArray: [AppRecordType] = [.defaultBook, .companyBook, .familyBook, .otherBook]
        var passArray = [PrivateBaseItemModel]()
        for subRecord in recordArray {
            let subArray = SandboxFileManager.shared.readPrivateItemModels(recordType: subRecord, itemType: .allItem).filter { subModel in
                return subModel.isSyncCloud
            }
            
            passArray += subArray
        }
        
        AppICloudManager.shared.deleteMultipleRecords(models: passArray, isDeleteLocal: false)
    }
    
    @objc func willEnterForegroundNoti() {
        
        self.checkAppleIDChanged()

        guard ScreenLockManager.shared.checkNeedsShowScreenLock() else {
            self.goMemberShipVC()
            return
        }
        
        let topController: UIViewController = self.currentViewController() ?? self
        debugPrint("topController = \(topController.className())")
        if topController is PasscodeVerifyViewController {
            return
        }
        
        let screenVC = PasscodeVerifyViewController(false)
        screenVC.onRightCallBack = { [weak self] () in
            self?.goMemberShipVC()
        }
        let navVC = KakaNavigationController(rootViewController: screenVC)
        navVC.modalPresentationStyle = .fullScreen
        topController.present(navVC, animated: false, completion: nil)
    }
    
    @objc func handleCloudKitError(_ ckNoti: Notification?) {
        guard let ckError = ckNoti?.object as? CKError else { return }
        
        let ckCode: CKError.Code = ckError.code
        var message: String = "iCloud synced exception, please try again later.".localStr()
        
        switch ckCode {
        case CKError.quotaExceeded:
            message = "Your iCloud storage is full. Please go to [Settings] to expand or clear unnecessary resources.".localStr()
            break
        case CKError.networkUnavailable:
            message = "The network seems to be disconnected".localStr()
            break
        case CKError.serviceUnavailable:
            message = "Service unavailable".localStr()
            break
        case CKError.limitExceeded:
            message = "The requested size exceeds the server's limit, please retry in batches.".localStr()
            break
        case CKError.incompatibleVersion:
            message = "The app version is lower than the minimum allowed version. Please upgrade the app.".localStr()
            break
        case CKError.zoneBusy:
            message = "The region is busy, please try again later.".localStr()
            break
        case CKError.notAuthenticated:
            message = "Your iCloud is either unavailable or not logged in, please go to [Settings] to enable your iCloud".localStr()
            break
        case CKError.requestRateLimited:
            message = "Client request restricted.".localStr()
            break
        case CKError.badContainer:
            message = "Unauthorized container or container not configured.".localStr()
            break
        case CKError.networkFailure:
            message = "Network error, error occurred while communicating with the iCloud server.".localStr()
            break
            
        default:
            message = "\(ckCode.rawValue)" + message
            break
        }
        
        (self.currentViewController() ?? self).showTwoAlert(title: "iCloud exception".localStr(), message: message, confirm: "Settings".localStr(), cancle: "Cancel".localStr()) {
            let urlStr = SystemSettingPath.iCloud.settingPathStr()
            guard let vUrl = URL(string: urlStr) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(vUrl) {
                UIApplication.shared.open(vUrl, options: [:], completionHandler: nil)
            }else{
                if let settingUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingUrl)
                }
            }
        }
        
        let feedModel = FeedbackModel(feedbackID: UUID().uuidString, type: .iCloudException, content: message)
        AppICloudManager.shared.addNewFeedBack(model: feedModel)
    }
    
    
    func checkAppleIDChanged() {
        
        if FileManager.default.ubiquityIdentityToken == nil {
            self.showAccountNotLoginTips()
            return
        }
        
        AppICloudManager.shared.defaultContainer.fetchUserRecordID { recordID, error in
            
            guard let vRecordID = recordID else {
                DispatchQueue.main.async { [weak self] () in
                    self?.showAccountNotLoginTips()
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] () in
                self?.showAccountChangedTips()
            }
            
        }
    }
    
    
    @objc func showAccountCanceledTips() {
        
        self.currentViewController()?.showOneAlert(title: "Please restart".localStr(), message: "PassLock has detected that you have logged out of your previously logged-in account. After we clear the local data, you will be forcibly logged out. Please restart".localStr(), confirm: "OK".localStr()) {
            AppLocalManager.reset()
            self.switchAppKeyWindow()
        }
        
    }
    
    @objc func showAccountChangedTips() {
        
        self.currentViewController()?.showOneAlert(title: "Please restart".localStr(), message: "PassLock has detected that you have switched Apple ID. To ensure the security of your data, please restart the application. Your existing data will not be deleted.".localStr(), confirm: "OK".localStr()) {
            AppLocalManager.reset()
            self.switchAppKeyWindow()
        }
    }
    
   func showAccountNotLoginTips() {
              
       self.currentViewController()?.showOneAlert(title: "Tip".localStr(), message: "Your iCloud is either unavailable or not logged in, please go to [Settings] to enable your iCloud".localStr(), confirm: "Settings".localStr()) {
           let settingUrl = SystemSettingPath.iCloud.settingPathStr()

           if let privacyURL = URL(string: settingUrl) {
               if UIApplication.shared.canOpenURL(privacyURL) {
                   UIApplication.shared.open(privacyURL, options: [:]) { finish in
                       self.switchAppKeyWindow()
                   }
               }else{
                   if let vUrl = URL(string: UIApplication.openSettingsURLString) {
                       UIApplication.shared.open(vUrl, options: [:]) { finish in
                           self.switchAppKeyWindow()
                       }
                   }
               }
           }
       }
    }
    
    func switchAppKeyWindow() {
        let tabbarVC = WelcomeFirsterViewController()
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = tabbarVC
        scene?.window?.makeKeyAndVisible()
    }
}

