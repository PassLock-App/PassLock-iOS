//
//  HomeSplitViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class HomeSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        self.delegate = self
        self.primaryBackgroundStyle = .sidebar
        self.preferredPrimaryColumnWidth = kaka_IsiPad() ? 300 : 220.ckValue()
        self.maximumPrimaryColumnWidth = kaka_IsiPad() ? 300 : 280.ckValue()
        self.showsSecondaryOnlyButton = true
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .displace
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func preSetupHandleBuness() {
                
        self.setViewController(KakaNavigationController(rootViewController: tabbarVC), for: .primary)
        
        let setVC = KakaNavigationController(rootViewController: ProfileViewController())
        self.setViewController(setVC, for: .secondary)
        self.controllerDict[MacTabbarCellItemType.userCenter.rawValue] = setVC
                
        self.addObserviseNoti()
    }
    
    lazy var tabbarVC: MacTabbarViewController = {
        let tabbarVC = MacTabbarViewController()
        tabbarVC.delegate = self
        return tabbarVC
    }()
    
    lazy var controllerDict: [String: KakaNavigationController?] = {
        return [String: KakaNavigationController?]()
    }()
    
    lazy var appstoreManager: KakaAppStoreManager = {
        return KakaAppStoreManager()
    }()
}

extension HomeSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, shouldHide vc: UIViewController, in orientation: UIInterfaceOrientation) -> Bool {
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

        guard let secondaryAsNavController = secondaryViewController as? UINavigationController, let topAsDetailController = secondaryAsNavController.topViewController as? PasswordViewController else {
            return false
        }
        
        return true
    }
    
}

extension HomeSplitViewController: MacTabbarViewControllerDelegate {
    
    func macTabbarViewControllerDidSelectUser(controller: MacTabbarViewController) {
        guard let loadedVC = self.controllerDict[MacTabbarCellItemType.userCenter.rawValue] as? KakaNavigationController else {
            let setVC = KakaNavigationController(rootViewController: ProfileViewController())
            self.setViewController(setVC, for: .secondary)
            self.controllerDict[MacTabbarCellItemType.userCenter.rawValue] = setVC
            return
        }
        
        self.setViewController(loadedVC, for: .secondary)
        
    }
    
    func macTabbarViewController(controller: MacTabbarViewController, otherType: MacTabbarCellItemType) {
        
        guard let loadedVC = self.controllerDict[otherType.rawValue] as? KakaNavigationController else {
            
            if otherType == .currentvault {
                let scanVC = KakaNavigationController(rootViewController: SwitchPassViewController())
                scanVC.modalPresentationStyle = .automatic
                self.present(scanVC, animated: true)
            }else if otherType == .allItems {
                let setVC = KakaNavigationController(rootViewController: PasswordViewController(.allItem))
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }else if otherType == .loginItems {
                let setVC = KakaNavigationController(rootViewController: PasswordViewController(.password))
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }else if otherType == .fileItems {
                let setVC = KakaNavigationController(rootViewController: PasswordViewController(.photoVault))
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }else if otherType == .noteItems {
                let setVC = KakaNavigationController(rootViewController: PasswordViewController(.secretNotes))
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }else if otherType == .downloadIOS {
                let scanVC = KakaNavigationController(rootViewController: ScanPlatViewController())
                scanVC.modalPresentationStyle = .automatic
                self.present(scanVC, animated: true)
            }else if otherType == .strongPass {
                let setVC = KakaNavigationController(rootViewController: PassCreaterViewController())
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }else if otherType == .transparency {
                let setVC = KakaNavigationController(rootViewController: TransparencyViewController())
                self.setViewController(setVC, for: .secondary)
                self.controllerDict[otherType.rawValue] = setVC
            }
            return
        }
        
        self.setViewController(loadedVC, for: .secondary)
    }
    
    func macTabbarViewControllerDidAddItem(controller: MacTabbarViewController, addCell: MacAddItemViewCell) {
        self.addPrivateItemClick(addCell)
    }
    
}
