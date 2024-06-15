//
//  AddPrivateNoteViewController+Delegate.swift
//  PassLock
//
//  Created by melo on 2024/1/14.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import CloudKit
import MBProgressHUD

extension AddPrivateNoteViewController {
    
    @objc public func saveButtonClick() {
        guard var vModel = self.model else { return }
        
        self.view.endEditing(true)
        
        guard let customTitle = vModel.customTitle, customTitle.count > 0 else {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddNoteTitleViewCell
            cell?.kaka_playShakeAnim()
            return
        }
        
        guard let notes = vModel.notes, notes.count > 0 else {
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddNoteContentViewCell
            cell?.kaka_playShakeAnim()
            return
        }
                      
        if self.isEditVC {
            if vModel == originalModel {
                self.cancelBarButtonClick()
                return
            }
            
            MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
            AppICloudManager.shared.updateOnePrivateItem(model: vModel, originalModel: originalModel) { [weak self] resultModel in
                guard let wSelf = self else { return }
                MBProgressHUD.hideLoading(wSelf.view)
                wSelf.model = resultModel
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
    
}
