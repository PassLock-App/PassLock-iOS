//
//  AddAccountPassViewController+Handle.swift
//  PassLock
//
//  Created by melo on 2024/6/4.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD
import CloudKit

extension AddAccountPassViewController {
    
    func preloadModeldata() {
        let recordType: AppRecordType = AppICloudManager.shared.currentPassbook.recordType
                
        guard let vModel = self.model else {
            let record = CKRecord(recordType: recordType.rawValue)

            var defaultModel = PrivateBaseItemModel()
            defaultModel.recordType = recordType
            defaultModel.storageType = .password
            defaultModel.userID = ...
            defaultModel.customTitle = nil
            defaultModel.recordId = record.recordID.recordName
            defaultModel.isSyncCloud = isSyncCloud
            defaultModel.passwordModel = PrivateAccountModel()
            self.model = defaultModel
            self.tableView.reloadData()
            return
        }
        
        self.historyPassArray = vModel.passwordModel?.passwords ?? []
        
        guard let assetIdArray = vModel.assetIdArray, assetIdArray.count > 0 else {
            self.model?.tempAssetArray = [SingleFileModel]()
            self.tableView.reloadData()
            return
        }
        
        var tempArray = [SingleFileModel?]()
        for index in 0..<assetIdArray.count {
            let recordID = assetIdArray[index]
            let subModel = SandboxFileManager.shared.readPassFileAsset(recordType: vModel.recordType, recordId: recordID)
            tempArray.append(subModel)
        }
        
        self.model?.tempAssetArray = tempArray.compactMap({ $0 })
        self.tableView.reloadData()
    }
    
}


extension AddAccountPassViewController {
    @objc public func saveButtonClick() {
        guard var vModel = self.model else { return }
        
        self.view.endEditing(true)
        
        guard let customTitle = vModel.customTitle, customTitle.count > 0 else {
            guard let passCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddCustomTitleTableCell else { return }
            passCell.kaka_playShakeAnim()
            return
        }
                
        guard let accountName = vModel.passwordModel?.accountName, accountName.count > 0 else {
            guard let passCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddUserNameTableCell else { return }
            passCell.kaka_playShakeAnim()
            return
        }
        
        guard let password = vModel.passwordModel?.passwords, password.count > 0 else {
            guard let passCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? AddPasswordTableCell else { return }
            passCell.kaka_playShakeAnim()
            return
        }
        
        vModel.assetIdArray = self.photoArray.compactMap({ $0?.recordId })
        
        if self.isEditVC {
            if vModel == originalModel {
                MBProgressHUD.hideLoading(self.view)
                self.cancelBarButtonClick()
                return
            }
            
            MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
            AppICloudManager.shared.updateOnePrivateItem(model: vModel, originalModel: originalModel) { [weak self] resultModel in
                guard let wSelf = self else { return }
                MBProgressHUD.hideLoading(wSelf.view)
                wSelf.model = resultModel
                wSelf.tableView.reloadData()
                wSelf.onSaveCallBack?(resultModel)
                LocalNotificationManager.shared.addOrUpdatePassNoti(resultModel)
                wSelf.cancelBarButtonClick()
            } fail: { [weak self] error in
                guard let wSelf = self else { return }
                MBProgressHUD.hideLoading(wSelf.view)
                wSelf.view.makeToast(error?.localizedDescription ?? "")
            }
        } else {
            MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
            vModel.createDate = Date().timeIntervalSince1970
            vModel.modifyDate = Date().timeIntervalSince1970
            AppICloudManager.shared.saveMultipleRecords(models: [vModel]) { [weak self] models in
                guard let wSelf = self else { return }
                MBProgressHUD.hideLoading(wSelf.view)
                guard let saveModel = models.first else {
                    return
                }
                wSelf.model = saveModel
                wSelf.tableView.reloadData()
                wSelf.onSaveCallBack?(saveModel)
                LocalNotificationManager.shared.addOrUpdatePassNoti(saveModel)
                wSelf.cancelBarButtonClick()
            } fail: { [weak self] error in
                guard let wSelf = self else { return }
                MBProgressHUD.hideLoading(wSelf.view)
                guard let ckError = error as? CKError, vModel.isSyncCloud else {
                    wSelf.view.makeToast(error?.localizedDescription ?? "")
                    return
                }
                
                vModel.isSyncCloud = false
                NotificationCenter.default.post(name: NSNotification.Name(kSaveOrUpdateAccountKey), object: vModel, userInfo: nil)
            }
        }
        
    }
    
    func checkLocalAsset() {
        guard let tempAssetArray = self.model?.tempAssetArray, tempAssetArray.count > 0 else { return }
        
        tempAssetArray.forEach { subModel in
            SandboxFileManager.shared.deleteSingleFile(model: subModel)
        }
    }
    
}
