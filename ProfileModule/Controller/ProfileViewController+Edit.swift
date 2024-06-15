//
//  ProfileViewController+Avatar.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/4.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD

extension ProfileViewController: UIPopoverPresentationControllerDelegate {
    @objc func clickAvatarTap(_ userCell: UserBasicViewCell) {
                
        let avatarVC = SelectAvatarViewController()
        avatarVC.preferredContentSize = CGSize(width: 300.ckValue(), height: 330.ckValue())
        avatarVC.modalPresentationStyle = .popover
        let popVC = avatarVC.popoverPresentationController
        popVC?.delegate = self
        popVC?.backgroundColor = UIColor.clear
        popVC?.permittedArrowDirections = .up
        popVC?.sourceRect = userCell.avatarView.bounds
        popVC?.sourceView = userCell.avatarView
        self.present(avatarVC, animated: true)
        
    }
    
    func loginPushAction() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
 
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func editNameTap() {
       
        let editAlertVC = UIAlertController(title: "Edit nickname".localStr(), message: nil, preferredStyle: .alert)
        editAlertVC.addTextField { textView in
            let placeText = userModel.nickName ?? ""
            let placeAttbute = NSAttributedString(string: placeText, attributes: [.font: UIFontLight(15.ckValue()), .foregroundColor: UIColor.placeholderText])
            textView.text = placeText
            textView.attributedPlaceholder = placeAttbute
            textView.clearButtonMode = .whileEditing
        }
        editAlertVC.addAction(UIAlertAction(title: "Cancel".localStr(), style: .cancel, handler: nil))
        editAlertVC.addAction(UIAlertAction(title: "Done".localStr(), style: .default, handler: { action in
            guard let nameField = editAlertVC.textFields?.first, let nameText = nameField.text, nameText.count > 0 else {
                return
            }
            
            userModel.nickName = nameText
            AppICloudManager.shared.syncPrivateAndPublicUser(userModel: userModel) {
                self.tableView.reloadData()
            }

        }))
        self.present(editAlertVC, animated: true)
    }
    
}
