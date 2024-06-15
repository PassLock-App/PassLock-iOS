//
//  HomeSplitViewController+Add.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import AppGroupKit

extension HomeSplitViewController: UIPopoverPresentationControllerDelegate {

    func addPrivateItemClick(_ addCell: MacAddItemViewCell) {
                
        let dataArray: [StorageItemType] = [.password, .photoVault, .secretNotes]
        var contentSize = CGSize(width: self.view.width * 0.5, height: 0)
        dataArray.forEach { subType in
            let size = AddPassTypeTablecell.cellContentSize(maxWidth: contentSize.width, storage: subType)
            contentSize.height += size.height
        }
        
        let passTypeVC = SwitchItemTypePopController(dataArray)
        passTypeVC.onSelectCallBack = { [weak self] (passType) in
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
        popVC?.permittedArrowDirections = .any
        popVC?.sourceRect = addCell.addBackView.bounds
        popVC?.sourceView = addCell.addBackView
        self.present(passTypeVC, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
}


extension HomeSplitViewController {
    
    func addPasswordItem() {
        let addVC = AddAccountPassViewController(nil)
        addVC.onSaveCallBack = { [weak self] (accountModel) in
            self?.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
    func addPhotoVaultItem() {
        let addVC = AddPrivateFileViewController(nil)
        addVC.onSaveCallBack = { [weak self] (accountModel) in
            self?.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
    func addPrivateNoteItem() {
        let addVC = AddPrivateNoteViewController(nil)
        addVC.onSaveCallBack = { [weak self] (accountModel) in
            self?.addOrUpdateAccount(accountModel)
        }
        let navVC = KakaNavigationController(rootViewController: addVC)
        navVC.modalPresentationStyle = kaka_IsiPhone() ? .fullScreen : .automatic
        self.present(navVC, animated: true)
    }
    
    
    
}
