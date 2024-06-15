//
//  AddAccountPassViewController+Delegate.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/5/7.
//

import KakaFoundation
import KakaUIKit
import SafariServices
import AppGroupKit
import Toast_Swift
import KakaPhotoBrowser
import CloudKit

extension AddAccountPassViewController: AddAccountPassDelegate {
    
    func editCustomTitleWithCell(cell: AddCustomTitleTableCell, customTitle: String?) {
        self.model?.customTitle = customTitle
        
        self.headView.model = self.model
    }
    
    func editUsernameWithCell(cell: AddUserNameTableCell, userName: String?) {
        self.model?.passwordModel?.accountName = userName
    }
    
    func editPasswordWithCell(cell: AddPasswordTableCell, password: String?) {
        guard let newPass = password, newPass.count > 0 else { return }
        let newModel = PasswordListModel(passwordID: CKRecord(recordType: CloudRecordType_CopiedPasswords).recordID.recordName, password: newPass, createTime: Date().timeIntervalSince1970.rounded(), deviceType: kaka_osType())
        self.addOneNewPassword(newModel)
    }
    
    func editNotesWithCell(cell: AddNotesTableCell, notes: String?) {
        self.model?.notes = notes
    }
    
    func addOneNewPassword(_ passModel: PasswordListModel) {
        
        if passModel.password == self.model?.passwordModel?.passwords?.first?.password { return }
        
        if !self.isEditVC {
            self.model?.passwordModel?.passwords = [passModel]
            return
        }
        
        var tempHistoryPassArray = self.historyPassArray
        tempHistoryPassArray.insert(passModel, at: 0)
        self.model?.passwordModel?.passwords = tempHistoryPassArray
    }
    
    func showSelectAttachPicker() {
        self.view.endEditing(true)
        
        if self.photoArray.count >= kPasswordFileMaxCount {
            let message = String(format: "Supports up to %@ attachments, please slide to delete.".localStr(), "\(kPasswordFileMaxCount)")
            self.view.makeToast(message)
            return
        }
        
        let alerController = UIAlertController(title: "Only Premium".localStr(), message: "Attachments only you can access worldwide".localStr(), preferredStyle: kaka_IsiPhone() ? .actionSheet : .alert)
        let action0 = UIAlertAction(title: "Cancel".localStr(), style: .cancel, handler: nil)
        alerController.addAction(action0)
        
        if !kaka_IsMacOS() {
            let action1 = UIAlertAction(title: "Scan for files".localStr(), style: .default) { [weak self] _ in
                guard let wSelf = self else { return }
                
                wSelf.selectImageFromScan()
            }
            alerController.addAction(action1)
        }
        
        let action2 = UIAlertAction(title: kaka_IsMacOS() ? "Open in finder".localStr() : "iCloud Files".localStr(), style: .default) { [weak self] _ in
            guard let wSelf = self else { return }
           
            wSelf.selectFileFromDocument()
        }
        let action3 = UIAlertAction(title: "Select Photos".localStr(), style: .default) { [weak self] _ in
            guard let wSelf = self else { return }
            
            wSelf.selectImageFromLibrary()
        }
        
        alerController.addAction(action2)
        alerController.addAction(action3)
        
        self.present(alerController, animated: true)
    }
    
    func deleteAttachAction(_ index: Int) {
        if self.isEditVC {
            if let tempIdArray = self.model?.assetIdArray, tempIdArray.count > 0 {
                self.model?.assetIdArray?.remove(at: index)
            }
                  
            if let tempArray = self.model?.tempAssetArray, tempArray.count > 0 {
                let fileModel = tempArray[index]
                SandboxFileManager.shared.deleteSingleFile(model: fileModel)
                self.model?.tempAssetArray?.remove(at: index)
            }
            
            self.tableView.reloadData()
        }else{
            if let tempArray = self.model?.tempAssetArray, tempArray.count > 0 {
                let fileModel = tempArray[index]
                SandboxFileManager.shared.deleteSingleFile(model: fileModel)
                self.model?.tempAssetArray?.remove(at: index)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func attachTableCellClick(_ indexPath: IndexPath) {
        var tempArray = [KakaPhotoItem]()
        for index in 0..<photoArray.count {
            let fileModel = photoArray[index]
            let subImgView = UIImageView(image: fileModel?.assetImage() ?? Reasource.systemNamed("icloud.and.arrow.down", color: UIColor.lightGray))
            subImgView.isHidden = true
            subImgView.frame = CGRectMake(self.view.width / 2, self.view.height / 2, 1, 1)
            self.view.addSubview(subImgView)
            
            let item = KakaPhotoItem(sourceView: subImgView, image: subImgView.image)
            tempArray.append(item)
        }
        
        let browser = KakaPhotoBrowser(photoItems: tempArray, selectedIndex: UInt(indexPath.row))
        browser.backgroundStyle = .blurPhoto
        browser.show(from: self)
    }
    
    func guideGotoModifyPassword(_ passModel: PasswordListModel) {
        UIPasteboard.general.string = passModel.password
        self.view.makeToast("Copied Successful".localStr())
    }
    
}



