//
//  TransparencyViewController+Data.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/26.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import StoreKit
import SafariServices
import MessageUI

extension TransparencyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = self.dataArray[indexPath.section]
        let itemType = groupModel.itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransparencyTableCell", for: indexPath) as! TransparencyTableCell
        cell.itemType = itemType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupModel = self.dataArray[indexPath.section]
        let itemType = groupModel.itemArray[indexPath.row]
        
        if itemType == .openSource {
            guard let vURL = URL(string: kOpenSourceUrl) else { return }
            if kaka_IsMacOS() {
                UIApplication.shared.open(vURL)
            } else {
                let safariVC = SFSafariViewController(url: vURL)
                safariVC.delegate = self
                safariVC.preferredControlTintColor = appMainColor
                self.present(safariVC, animated: true)
            }
        }
        
        if itemType == .faqs {
            let faqVC = FAQsViewController()
            self.navigationController?.pushViewController(faqVC, animated: true)
        }
        
        if itemType == .contactMail {
            self.handleWithEmail()
        }
        
        if itemType == .producuStory {
            guard let vURL = URL(string: kProductDocumentUrl) else { return }
            if kaka_IsMacOS() {
                UIApplication.shared.open(vURL)
            } else {
                let safariVC = SFSafariViewController(url: vURL)
                safariVC.preferredControlTintColor = appMainColor
                self.present(safariVC, animated: true)
            }
        }
        
        if itemType == .iCloudBackup {
            let backVC = CloudKitConsoleViewController()
            self.navigationController?.pushViewController(backVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footTitle
    }
    
}



extension TransparencyViewController: GuideRateReviewViewDelegate, UIPopoverPresentationControllerDelegate, SFSafariViewControllerDelegate {
    
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
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

extension TransparencyViewController: MFMailComposeViewControllerDelegate {
    func handleWithEmail() {
        if !MFMailComposeViewController.canSendMail() {
            self.showOneAlert(title: "Tip".localStr(), message: "The native email app is not available, please copy the email".localStr(), confirm: "Copy".localStr()) {
                UIPasteboard.general.string = companyEmail
                self.view.makeToast("Copied Successful".localStr())
            }
            return
        }
        
        let emailVC = MFMailComposeViewController()
        emailVC.mailComposeDelegate = self
        emailVC.setToRecipients([companyEmail])
        self.present(emailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent {
            appKeyWindow?.makeToast("Thank you for your feedback".localStr())
        }
    }
}
