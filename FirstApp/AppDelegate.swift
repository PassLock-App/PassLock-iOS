//
//  AppDelegate.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/5.
//

import KakaFoundation
import KakaUIKit
import KakaObjcKit
import Reachability
import IQKeyboardManagerSwift
import CloudKit
import CryptoKit
import AppGroupKit
import Toast_Swift
import SDWebImageSVGCoder

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.setupApp()
        NetworkMonitor.shared.startMonitoring()
        return true
    }
    
    @objc func networkStatusChanged() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            self.prefetchSomeTask()
        }
    }
    
    func setupApp() {
        
        let toolBarAppearance = UIToolbarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        toolBarAppearance.configureWithDefaultBackground()
        UIToolbar.appearance().standardAppearance = toolBarAppearance
        UIToolbar.appearance().tintColor = appMainColor
        
        UIView.appearance().tintColor = appMainColor
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = appMainColor
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        if AppLocalManager.shared.saleModels.count != 3 {
            AppLocalManager.shared.saleModels = SaleInfoModel().defaultProducts()
        }
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        KakaAppStoreManager.finishTransactions()
        
        var toastStyle = ToastManager.shared.style
        toastStyle.cornerRadius = 2.ckValue()
        toastStyle.backgroundColor = UIColor.label
        toastStyle.verticalPadding = 12.ckValue()
        toastStyle.horizontalPadding = 18.ckValue()
        toastStyle.titleFont = UIFontLight(15.ckValue())
        toastStyle.messageFont = UIFontLight(15.ckValue())
        toastStyle.titleAlignment = .center
        toastStyle.messageAlignment = .center
        toastStyle.titleColor = UIColor.systemBackground
        toastStyle.messageColor = UIColor.systemBackground
        ToastManager.shared.style = toastStyle
        ToastManager.shared.position = .center
        
        self.supportArabic()
        
    }
    
    @objc func prefetchSomeTask() {
        self.registerLocalNotification()
    }
    
    func supportArabic() {
        let semanticContentAttribute = PhoneSetManager.isArabicLanguage() ? UISemanticContentAttribute.forceRightToLeft : UISemanticContentAttribute.forceLeftToRight
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UISearchBar.appearance().semanticContentAttribute = semanticContentAttribute
        
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let defaultConfig = UISceneConfiguration(name: "MainConfiguration", sessionRole: connectingSceneSession.role)
        return defaultConfig
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("⏰Will enter background")
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("⏏️App was Killed")
        ScreenLockManager.shared.didEnterBackgroundNoti()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.removePushNotiBadge()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch kaka_osType() {
        case .iOS: return .portrait
        case .iPadOS: return .all
        case .macOS: return .allButUpsideDown
        }
    }
    
}
