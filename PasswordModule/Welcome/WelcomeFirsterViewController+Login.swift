//
//  WelcomeFirsterViewController+Login.swift
//  PassLock
//
//  Created by Melo on 2023/9/23.
//

import KakaFoundation
import KakaUIKit
import MBProgressHUD
import AppGroupKit
import CloudKit
import CryptoKit
import Toast_Swift


extension WelcomeFirsterViewController {
    
    @objc func signinWithAppleID() {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        UserInfoManager.shared.loginOrRegisterOrFetchCloud { [weak self] model in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.loginSuccess()
        } fail: { [weak self] errorMsg in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.loginSuccess()
        }
        
    }
    
    func loginSuccess() {
        let setVC = PasscodeSetViewController()
        setVC.onCallBack = { [weak self] (success) in
            if success {
                self?.finishAllPage()
            }else{
                var screenModel = ScreenLockManager.shared.getScreenPassCode()
                screenModel.isPasswordEnble = false
                screenModel.password = nil
                ScreenLockManager.shared.saveScreenPassCode(screenModel)
            }
        }
        
        let navVC = KakaNavigationController(rootViewController: setVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func finishAllPage() {
        
        self.view.isUserInteractionEnabled = false
        AppLocalManager.shared.isShowedWelcome = true
        AppLocalManager.shared.firstEnterTime = Date().timeIntervalSince1970
        
        let ani: CATransition = CATransition()
        ani.type = CATransitionType(rawValue: "cube")
        ani.subtype = CATransitionSubtype.fromRight
        ani.duration = 0.55
        ani.isRemovedOnCompletion = true
        appKeyWindow?.layer.add(ani, forKey: nil)
        
        self.perform(#selector(dismissAnimation), afterDelay: ani.duration - 0.1)
    }
    
    @objc func dismissAnimation() {
        let homeVC = kaka_IsiPhone() ? HomeTabbarViewController() : HomeSplitViewController(style: .doubleColumn)
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = homeVC
        scene?.window?.makeKeyAndVisible()
    }
    
}
