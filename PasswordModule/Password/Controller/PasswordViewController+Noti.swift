//
//  PasswordViewController+Noti.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/13.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import StoreKit

extension PasswordViewController: UIPopoverPresentationControllerDelegate {
    
    func addNetworkStatus() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.preloadPrivateItems()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(shareAccountHealth(_:)), name: NSNotification.Name(rawValue: kShareAccountHealthKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePrivateItem(_:)), name: NSNotification.Name(rawValue: kDeletePrivateItemKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrUpdateAccountOnMacOS(_:)), name: NSNotification.Name(rawValue: kSaveOrUpdateAccountKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableViews), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshDataAction), name: NSNotification.Name(rawValue: kICloudPassBookChangedKey), object: nil)

    }
    
    @objc func addOrUpdateAccountOnMacOS(_ noti: Notification) {
        guard let model = noti.object as? PrivateBaseItemModel else { return }
        self.addOrUpdateAccount(model)
        
        let currentVC = self.currentViewController()
        if (currentVC is PasswordDetialViewController) || (currentVC is PasswordViewController) || (currentVC is HomeTabbarViewController) || (currentVC is HomeSplitViewController) || (currentVC is AddAccountPassViewController) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
        
    }
    
    @objc func purchargeItemClick() {
        KakaAppStoreManager.presentPurcharseVC(self)
    }
    
    @objc func shareAccountHealth(_ noti: Notification) {
        guard let shareImage = noti.object as? UIImage else { return }
        
        let shareVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        if !kaka_IsiPhone() {
            shareVC.preferredContentSize = CGSize(width: 500.ckValue(), height: 450.ckValue())
            shareVC.modalPresentationStyle = .popover
            
            let popVC = shareVC.popoverPresentationController
            popVC?.delegate = self
            popVC?.backgroundColor = UIColor.clear
            popVC?.permittedArrowDirections = .down
            popVC?.sourceRect = self.healthView.bounds
            popVC?.sourceView = self.healthView
        }
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @objc func deletePrivateItem(_ noti: Notification) {
        guard let vModel = noti.object as? PrivateBaseItemModel else { return }
        
        let tempArray = self.viewModel.originDataArray.filter { return $0.recordId != vModel.recordId }
        self.viewModel.originDataArray = tempArray
        self.reloadTableViews()
        LocalNotificationManager.shared.deletePassNoti(vModel)
    }
    
    @objc func preloadPrivateItems() {
        AppICloudManager.shared.preloadPassFileAsset()
        AppICloudManager.shared.preloadRemoteWebsite()
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
