//
//  HomeTabbarViewController+Add.swift
//  PassLock
//
//  Created by Melo on 2024/6/2.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

extension HomeTabbarViewController: UIPopoverPresentationControllerDelegate {
    
    @objc func plusButtonClick() {
        
        self.kakaTabbar?.startArrowAnimation()
        
        let dataArray: [StorageItemType] = [.password, .photoVault, .secretNotes]
        var contentSize = CGSize(width: self.view.width - 40.ckValue(), height: 0)
        dataArray.forEach { subType in
            let size = AddPassTypeTablecell.cellContentSize(maxWidth: contentSize.width, storage: subType)
            contentSize.height += size.height
        }
        
        let passTypeVC = SwitchItemTypePopController(dataArray)
        passTypeVC.onSelectCallBack = { [weak self] (passType) in
            self?.kakaTabbar?.stopArrowAnimation()
            
            if passType == .password {
                self?.addPasswordItem()
            } else if passType == .photoVault {
                self?.addPhotoVaultItem()
            }else if passType == .secretNotes {
                self?.addPrivateNoteItem()
            }
        }
        passTypeVC.preferredContentSize = contentSize
        passTypeVC.modalPresentationStyle = .popover
        let popVC = passTypeVC.popoverPresentationController
        popVC?.delegate = self
        popVC?.backgroundColor = UIColor.clear
        popVC?.permittedArrowDirections = .down
        popVC?.sourceRect = self.kakaTabbar?.plusButton.bounds ?? self.tabBar.bounds
        popVC?.sourceView = self.kakaTabbar?.plusButton ?? self.tabBar
        self.present(passTypeVC, animated: true)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        self.kakaTabbar?.stopArrowAnimation()
        return true
    }
    
}


extension HomeTabbarViewController {
    
    func addPasswordItem() {
        let addVC = AddAccountPassViewController(nil)
        addVC.onSaveCallBack = { (accountModel) in
            guard let passVC = self.children.first as? PasswordViewController else { return }
            passVC.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
    
    func addPhotoVaultItem() {
        let addVC = AddPrivateFileViewController(nil)
        addVC.onSaveCallBack = { (accountModel) in
            guard let passVC = self.children.first as? PasswordViewController else { return }
            passVC.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
    func addPrivateNoteItem() {
        let addVC = AddPrivateNoteViewController(nil)
        addVC.onSaveCallBack = { (accountModel) in
            guard let passVC = self.children.first as? PasswordViewController else { return }
            passVC.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
}
