//
//  PassCreaterViewController+Data.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import Social
import StoreKit
import CloudKit

extension PassCreaterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataType = self.dataArray[indexPath.section]
        if dataType == .welcomeCard {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomeCreatePassCell", for: indexPath) as! WelcomeCreatePassCell
            
            return cell
        }else if dataType == .createPass {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneratePassTableCell", for: indexPath) as! GeneratePassTableCell
            cell.delegate = self
            return cell
        } else if dataType == .whyStrongPass {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StrongPasswordViewCell", for: indexPath) as! StrongPasswordViewCell
            cell.model = self.strongPass1
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StrongPasswordViewCell", for: indexPath) as! StrongPasswordViewCell
            cell.model = self.strongPass2
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataType = self.dataArray[indexPath.section]
        
        
    }
    
}

extension PassCreaterViewController: GeneratePassTableCellDelegate {
    func passCellCopyed(cell: GeneratePassTableCell, password: String) {
        
        let passModel = PasswordListModel(passwordID: CKRecord(recordType: CloudRecordType_CopiedPasswords).recordID.recordName, password: password, createTime: Date().timeIntervalSince1970, deviceType: kaka_osType())

        AppICloudManager.shared.savePasswordRecord(passModel)
        
        if let onCopyCallBack = self.onCopyCallBack {
            onCopyCallBack(passModel)
            self.navigationController?.popViewController(animated: true)
        }
                
    }
    
    func passCellCreatedSuccess(cell: GeneratePassTableCell, password: String) {
        self.tableView.reloadData()
    }
    
}


extension PassCreaterViewController: GuideRateReviewViewDelegate, UIPopoverPresentationControllerDelegate {
    
    func guideCommentDidScore(cell: GuideRateReviewView) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    func guideCommentDidShare(cell: GuideRateReviewView) {
        
        guard let vUrl = URL(string: "https://apps.apple.com/app/id\(appstoreID)") else {
            return
        }
        
        if kaka_IsMacOS() {
            self.showOneAlert(title: "Tip".localStr(), message: vUrl.absoluteString, confirm: "Copy".localStr()) {
                UIPasteboard.general.string = vUrl.absoluteString
                self.view.makeToast("Copied Successful".localStr())
            }
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: [vUrl], applicationActivities: nil)
        if !kaka_IsiPhone() {
            shareVC.preferredContentSize = CGSize(width: 500.ckValue(), height: 450.ckValue())
            shareVC.modalPresentationStyle = .popover
            
            let popVC = shareVC.popoverPresentationController
            popVC?.delegate = self
            popVC?.backgroundColor = UIColor.clear
            popVC?.permittedArrowDirections = .down
            popVC?.sourceRect = CGRectMake(0, 0, kaka_screen_width(), kaka_screen_height())
            popVC?.sourceView = self.contentView
        }
        self.present(shareVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
