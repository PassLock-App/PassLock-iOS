//
//  HomeTabbarViewController.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import AppGroupKit
import MBProgressHUD

enum KakaTabbarItem: Int {
    case unKnow = -1
    case passwords = 0
    case creater = 1
    case developer = 2
    case profile = 3
    
    func formatStr() -> String {
        switch self {
        case .unKnow: return ""
        case .passwords: return "Passwords".localStr()
        case .creater: return "Generator".localStr()
        case .developer: return "Transparency".localStr()
        case .profile: return "Profile".localStr()
        }
    }
}

var app_tabbar_height: CGFloat {
    get {
        switch kaka_osType() {
        case .iOS: return kaka_safeAreaInsets().bottom * 0.7 + 64
        case .iPadOS: return 210.ckValue()
        case .macOS: return 208
        }
        
    }
}


class HomeTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        self.handleAppSwitchedMode(UITraitCollection.current.userInterfaceStyle)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    private func preSetupHandleBuness() {
        
        self.addObserviseNoti()
        
        self.initSubController()
        
        self.appearanceChanged()
        
    }
    
    public func selectItemClick(_ item: KakaTabbarItem) {
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let userInterfaceStyle = previousTraitCollection?.userInterfaceStyle else { return }
        self.handleAppSwitchedMode(userInterfaceStyle)
    }
    
    func handleAppSwitchedMode(_ style: UIUserInterfaceStyle) {
        
        let userInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.overrideUserInterfaceStyle = userInterfaceStyle
        self.tabBar.overrideUserInterfaceStyle = userInterfaceStyle
    }
        
    // MARK:  GET && SET
    var kakaTabbar: KakaTabbarView?
    
    // MARK:  Lazy Init
    lazy var appstoreManager: KakaAppStoreManager = {
        return KakaAppStoreManager()
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let viewControllers = self.viewControllers, viewControllers.count > 0 {
            return viewControllers[self.selectedIndex].supportedInterfaceOrientations
        }
        
        return .all
    }
    
}

