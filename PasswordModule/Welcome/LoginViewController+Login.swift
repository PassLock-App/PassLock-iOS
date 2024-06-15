//
//  LoginViewController+Login.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import KakaUIKit
import KakaObjcKit
import AppGroupKit
import Toast_Swift
import MBProgressHUD
import CloudKit
import CryptoKit

extension LoginViewController {
    
    @objc func signinButtonClick() {
        
        guard self.checkIcloudStatus() else {
            return
        }
        
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        UserInfoManager.shared.loginOrRegisterOrFetchCloud { [weak self] model in
            self?.restoreButtonClick()
        } fail: { [weak self] errorMsg in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast(errorMsg)
        }

    }
    
    @objc func restoreButtonClick() {
        self.purchaseManager.restorePurcharge { [weak self] () in
            self?.verfityPurchageRecord()
        } fail: { [weak self] errorMsg in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast(errorMsg)
        }
    }
    
    func verfityPurchageRecord() {
        let localReceipt = self.purchaseManager.localReceiptData()
        if localReceipt.count <= 100 {
            MBProgressHUD.hideLoading(self.view)
            return
        }

        self.purchaseManager.validatorReceipt(receiptStr: localReceipt, transactionID: nil) { [weak self] allModel in
            guard let wSelf = self else { return }
            wSelf.purchaseManager.handlePayBigModel(allModel: allModel)
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast("Successful".localStr())
        } fail: { [weak self] errorMsg in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast(errorMsg)
        }
    }
    
    func checkIcloudStatus() -> Bool {
        guard let _ = FileManager.default.ubiquityIdentityToken else {
            // iCloud不可用，或者未登录
            self.showTwoAlert(message: "Your iCloud is either unavailable or not logged in, please go to [Settings] to enable your iCloud".localStr(), confirm: "Settings".localStr(), cancle: "Cancel".localStr()) {
                let settingUrl = SystemSettingPath.iCloud.settingPathStr()

                if let privacyURL = URL(string: settingUrl) {
                    if UIApplication.shared.canOpenURL(privacyURL) {
                        UIApplication.shared.open(privacyURL, options: [:])
                    }else{
                        if let vUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(vUrl, options: [:])
                        }
                    }
                }
            }
            return false
        }
        
        return true
    }
    
}

