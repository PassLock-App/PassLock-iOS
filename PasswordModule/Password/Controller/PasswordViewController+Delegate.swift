//
//  PasswordViewController+Delegate.swift
//  PassLock
//
//  Created by Melo Dreek on 2023/6/22.
//

import KakaFoundation
import KakaUIKit
import MBProgressHUD
import AppGroupKit
import SafariServices
import Toast_Swift

extension PasswordViewController {

    func newsActileClick(_ newsModel: SocialEventModel) {
        let newsVC = SocialNewsViewController(newsModel)
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
    
    func darkwebDetectClick() {
        
    }
    
    @objc func morePrivacyClick() {
        let privacyVC = MorePrivacyViewController()
        privacyVC.onAddCallBack = { [weak self] (model) in
            self?.addOrUpdateAccount(model)
        }
        self.navigationController?.pushViewController(privacyVC, animated: true)
    }
}

extension PasswordViewController: PasswordHealthViewDelegate {
    
    func passwordHealthViewClickGuide(headView: PasswordHealthView) {
        let message1 = "Set a strong, unique password for each account and changing it regularly is the only way to get perfect scores.".localStr()
        let message2 = "Total score = count of strong passwords / count of total passwords".localStr()
        let message = message1 + "\r\r" + message2
        
        self.showOneAlert(title: "Password Health".localStr(), message: message, confirm: "Done".localStr(), complete: nil)
        
    }
    
    func passwordHealthViewClickShare(headView: PasswordHealthView, score: Double, status: PassHealthStatus) {
        
        if kaka_IsMacOS() {
            let shareVC = ShareHealthScoreController(score: score, status: status)
            let navVC = KakaNavigationController(rootViewController: shareVC)
            navVC.modalPresentationStyle = kaka_IsMacOS() ? .automatic : .fullScreen
            self.present(navVC, animated: true)
        }else{
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let keyWindow = windowScene.windows.first else { return }

            let shareView = ShareHealthScoreView(frame: keyWindow.bounds, score: score, status: status)
            keyWindow.addSubview(shareView)
            shareView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    
    }
    
    func passwordHealthViewClickPieView(headView: PasswordHealthView, healthRisk: PassHealthRick) {
        
        if kaka_IsMacOS() {
            return
        }
        
        debugPrint("Click = \(healthRisk.formatStr())")
        self.viewModel.healthRisk = healthRisk
        
        self.viewModel.originDataArray = self.viewModel.originDataArray
        self.reloadTableViews()
        
        if healthRisk == .allData {
            if let guideView = self.view.viewWithTag(1080) as? HealthGuideTopView {
                UIView.animate(withDuration: 0.25) {
                    guideView.top = -guideView.height
                } completion: { finish in
                    guideView.removeFromSuperview()
                }
            }
            return
        }
        
        var count = 0
        switch healthRisk {
        case .allData:
            count = 0
        case .securety:
            count = self.healthView.safeCount
        case .easyGuess:
            count = self.healthView.easyCount
        case .duplicate:
            count = self.healthView.duplicateCount
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let keyWindow = windowScene.windows.first else { return }
        
        guard let healthView = keyWindow.viewWithTag(1080) as? HealthGuideTopView else {
            let healthView = HealthGuideTopView(frame: CGRectMake(0, -app_navHeight, self.view.width, app_navHeight))
            healthView.closeCallBack = { [weak self] () in
                guard let wSelf = self else { return }
                
                wSelf.viewModel.healthRisk = .allData
                wSelf.viewModel.originDataArray = wSelf.viewModel.originDataArray
                wSelf.reloadTableViews()
            
            }
            healthView.update(healthRisk: healthRisk, count: count)
            healthView.tag = 1080
            keyWindow.addSubview(healthView)
            
            UIView.animate(withDuration: 0.25) {
                healthView.top = 0
            } completion: { finish in
                
            }
            return
        }
        
        healthView.update(healthRisk: healthRisk, count: count)
    }
    
}

extension PasswordViewController {
    
    func clickPrivateItem(_ model: PrivateBaseItemModel) {
        let healArray = self.viewModel.sortHealthDataSource(model)
        
        self.passGroupCellDidSelect(model: model, healthArray: healArray)
    }
    
    func passGroupCellDidSelect(model: PrivateBaseItemModel, healthArray: [PassHealthRick]) {
        
        if model.storageType == .password {
            let editVC = PasswordDetialViewController(model: model, healthArray: healthArray)
            editVC.onSaveCallBack = { [weak self] (saveModel) in
                self?.addOrUpdateAccount(saveModel)
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        } else if model.storageType == .secretNotes {
            let editVC = NotesDetialViewController(model)
            editVC.onSaveCallBack = { [weak self] (saveModel) in
                self?.addOrUpdateAccount(saveModel)
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        } else if model.storageType == .photoVault {
            let editVC = PhotosDetialViewController(model)
            editVC.onSaveCallBack = { [weak self] (saveModel) in
                self?.addOrUpdateAccount(saveModel)
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        }else{
            
        }
        
    }
    
    func passGroupCellDidDelete(model: PrivateBaseItemModel) {
        let alertController: UIAlertController = UIAlertController(title: "Are you sure to delete this record?".localStr(), message: "Once deleted, it can't be recovered.".localStr(), preferredStyle: kaka_IsiPhone() ? .actionSheet : .alert)
        let action1: UIAlertAction = UIAlertAction(title: "Delete".localStr(), style: .destructive) { [weak self] (sender) in
            self?.deleteAccount(model)
        }
        
        let action2 : UIAlertAction = UIAlertAction(title: "Cancel".localStr(), style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true)
    }
    
    func passGroupCellDidCollect(model: PrivateBaseItemModel) {
        
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        var updateModel = model
        updateModel.isCollection = !updateModel.isCollection
        
        AppICloudManager.shared.updateOnePrivateItem(model: updateModel) { vModel in
            MBProgressHUD.hideLoading(self.view)
            var tempArray = self.viewModel.originDataArray
            for i in 0..<tempArray.count {
                let subModel = tempArray[i]
                if subModel.recordId == vModel.recordId {
                    tempArray[i] = vModel
                    break
                }
            }
            
            LocalNotificationManager.shared.addOrUpdatePassNoti(vModel)
            self.viewModel.originDataArray = tempArray
            self.reloadTableViews()
            
        } fail: { error in
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }
        
    }
    
    
    private func deleteAccount(_ model: PrivateBaseItemModel) {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.deleteMultipleRecords(models: [model]) { [weak self] models in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            guard let deleteModel = models.first else {
                return
            }
            
            let tempArray = wSelf.viewModel.originDataArray.filter { return $0.recordId != deleteModel.recordId }
            wSelf.viewModel.originDataArray = tempArray
            wSelf.reloadTableViews()
            LocalNotificationManager.shared.deletePassNoti(deleteModel)
        } fail: { error in
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }
    }
    
    func addOrUpdateAccount(_ saveModel: PrivateBaseItemModel) {
        
        var tempArray = self.viewModel.originDataArray
        
        let isContains = tempArray.filter({ $0.recordId == saveModel.recordId }).count > 0
        if isContains {
            tempArray = tempArray.map { return $0.recordId == saveModel.recordId ? saveModel : $0 }
        }else{
            tempArray.insert(saveModel, at: 0)
        }
        
        self.viewModel.healthRisk = .allData
        self.viewModel.originDataArray = tempArray
        self.reloadTableViews()
        
    }
    
}
