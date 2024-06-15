//
//  PhotosDetialViewController.swift
//  PassLock
//
//  Created by Melo on 2024/1/10.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD
import KakaPhotoBrowser

class PhotosDetialViewController: SuperViewController {
    
    init(_ model: PrivateBaseItemModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = self.view.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = StorageItemType.photoVault.nameStr()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit".localStr(), style: .done, target: self, action: #selector(editButtonClick))
        
        self.refreshDataAction()
    }
    
    func refreshDataAction() {
        self.dataArray.removeAll()
                
        var dateTimeStr = ""
        if let createDate = self.model.createDate {
            let createDate = Date(timeIntervalSince1970: createDate.rounded())
            let dateStr = createDate.dateString(ofStyle: .full)
            dateTimeStr.append("First created time:".localStr() + dateStr)
        }
        
        if let modifyDate = self.model.modifyDate {
            let modifyDate = Date(timeIntervalSince1970: modifyDate.rounded())
            let dateStr = modifyDate.dateString(ofStyle: .full)
            dateTimeStr.append("\r")
            dateTimeStr.append("Last modified time:".localStr() + dateStr)
        }
        
        let model0 = BaseItemGroupCellModel(group: .iconGroup, headTitle: nil, itemArray: [.icontitle], footTitle: nil)
        let model1 = BaseItemGroupCellModel(group: .notesGroup, headTitle: nil, itemArray: [.vaultType, .otherNote], footTitle: nil)
        let model2 = BaseItemGroupCellModel(group: .attachsGroup, headTitle: nil, itemArray: [.otherAttach], footTitle: nil)
        let model3 = BaseItemGroupCellModel(group: .actionGroup, headTitle: nil, itemArray: [.syncAction, .starAction, .deleteAction], footTitle: dateTimeStr)
        
        self.dataArray.append(model0)
        if let notes = self.model.notes?.removeSpace(), notes.count > 0 {
            self.dataArray.append(model1)
        }
        
        if let assetIdArray = self.model.assetIdArray, assetIdArray.count > 0 {
            self.dataArray.append(model2)
        }
        
        self.dataArray.append(model3)
        
        self.tableView.reloadData()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel!
    
    var onSaveCallBack: ((PrivateBaseItemModel)->Void)?
    
    var photoArray: [SingleFileModel?] {
        get {
            guard let assetIdArray = model.assetIdArray, assetIdArray.count > 0 else { return [] }
            var tempArray = [SingleFileModel?]()
            for index in 0..<assetIdArray.count {
                let recordID = assetIdArray[index]
                let subModel = SandboxFileManager.shared.readPassFileAsset(recordType: self.model.recordType, recordId: recordID)
                tempArray.append(subModel)
            }
            return tempArray
        }
    }
    
    lazy var dataArray: [BaseItemGroupCellModel] = {
        return [BaseItemGroupCellModel]()
    }()
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(DetialItemTitleViewCell.self, forCellReuseIdentifier: "DetialItemTitleViewCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "NotesTableViewCell")
        view.register(PasswordVaultTypeCell.self, forCellReuseIdentifier: "PasswordVaultTypeCell")
        view.register(PasswordAttachTableCell.self, forCellReuseIdentifier: "PasswordAttachTableCell")
        view.register(DetialItemActionViewCell.self, forCellReuseIdentifier: "DetialItemActionViewCell")
        return view
    }()
    
}

extension PhotosDetialViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupModel = dataArray[section]
        return groupModel.group == .attachsGroup ? self.photoArray.count : groupModel.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = dataArray[indexPath.section]

        if groupModel.group == .iconGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemTitleViewCell", for: indexPath) as! DetialItemTitleViewCell
            cell.model = self.model
            return cell
        }else if groupModel.group == .notesGroup {
            let itemType = groupModel.itemArray[indexPath.row]
            if itemType == .vaultType {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordVaultTypeCell", for: indexPath) as! PasswordVaultTypeCell
                cell.model = self.model
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath)
                var cellConfig = UIListContentConfiguration.valueCell()
                cellConfig.text = "Notes".localStr()
                cellConfig.secondaryText = self.model.notes ?? "N/A"
                cellConfig.prefersSideBySideTextAndSecondaryText = true
                cellConfig.textProperties.font = UIFontLight(15.ckValue())
                cellConfig.secondaryTextProperties.font = UIFontLight(11.ckValue())
                
                cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
                cellConfig.imageToTextPadding = 15
                
                cell.accessoryType = .disclosureIndicator
                cell.contentConfiguration = cellConfig
                return cell
            }
            
        }else if groupModel.group == .attachsGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordAttachTableCell", for: indexPath) as! PasswordAttachTableCell
            cell.update(itemModel: self.model, fileModel: self.photoArray[indexPath.row], index: indexPath.row + 1)
            return cell
        }else{
            let itemType = groupModel.itemArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemActionViewCell") as! DetialItemActionViewCell
            cell.updateItemType(model: self.model, itemType: itemType)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupModel = dataArray[indexPath.section]
        if groupModel.group == .attachsGroup {
            self.browerPhotoAction(indexPath)
            return
        }
        
        let itemType = groupModel.itemArray[indexPath.row]
        
        if itemType == .otherNote {
            UIPasteboard.general.string = self.model.notes
            self.view.makeToast("Copied Successful".localStr())
        }
        
        if itemType == .syncAction {
            self.synchronizeBarClick()
        }
        
        if itemType == .starAction {
            self.collectionAction()
        }
        
        if itemType == .deleteAction {
            let alertController: UIAlertController = UIAlertController(title: "Are you sure to delete this record?".localStr(), message: "Once deleted, it can't be recovered.".localStr(), preferredStyle: kaka_IsiPhone() ? .actionSheet : .alert)
            let action1: UIAlertAction = UIAlertAction(title: "Delete".localStr(), style: .destructive) { [weak self] (sender) in
                self?.deleteAction()
            }
            let action2 = UIAlertAction(title: "Cancel".localStr(), style: .cancel)
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.dataArray[section].footTitle
    }
}

extension PhotosDetialViewController {
    
    @objc func editButtonClick() {
        let editVC = AddPrivateFileViewController(model)
        editVC.onSaveCallBack = { [weak self] (saveModel) in
            self?.model = saveModel
            self?.onSaveCallBack?(saveModel)
            self?.refreshDataAction()
        }
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func synchronizeBarClick() {
        if self.model.isSyncCloud {
            self.view.makeToast("This item is synchronized".localStr())
            return
        }
        
        if ... {
            let alertController = UIAlertController(title: "Tip".localStr(), message: "This is a premium feature, please upgrade to premium to unlock all premium features.".localStr(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel".localStr(), style: .cancel) { (sender) in
                
            }
            let action2 = UIAlertAction(title: "Upgrade".localStr(), style: .destructive) { (sender) in
                KakaAppStoreManager.presentPurcharseVC(self)
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        self.model.isSyncCloud = true
        AppICloudManager.shared.saveMultipleRecords(models: [self.model]) { [weak self] models in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            guard let saveModel = models.first else {
                return
            }
            wSelf.model = saveModel
            wSelf.view.makeToast("Sync Successful".localStr())
            wSelf.refreshDataAction()
        } fail: { error in
            self.model.isSyncCloud = false
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }
    }
    
    func deleteAction() {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.deleteMultipleRecords(models: [self.model]) { [weak self] models in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            if let deleteModel = models.first {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDeletePrivateItemKey), object: deleteModel)
            }
            wSelf.navigationController?.popViewController(animated: true)
        } fail: { [weak self] error in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast(error?.localizedDescription)
        }
    }
    
    func browerPhotoAction(_ indexPath: IndexPath) {
        
        guard let cellView = tableView.cellForRow(at: indexPath) as? PasswordAttachTableCell else {
            return
        }
        
        guard let _ = photoArray[indexPath.row] else {
            if cellView.isAnimating() { return }
            cellView.startAnimating()
            guard let recordID = self.model.assetIdArray?[indexPath.row] else {
                self.view.makeToast("Null ID")
                return
            }
            
            AppICloudManager.shared.queryPassFileModel(recordID: recordID) { model in
                cellView.stopAnimating()
                self.refreshDataAction()
            } fail: { errorMsg in
                cellView.stopAnimating()
            }

            return
        }
        
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
    
    func collectionAction() {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        var updateModel: PrivateBaseItemModel = self.model
        updateModel.isCollection = !updateModel.isCollection
        
        AppICloudManager.shared.updateOnePrivateItem(model: updateModel) { [weak self] vModel in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.model = vModel
            wSelf.tableView.reloadData()
            wSelf.onSaveCallBack?(vModel)
        } fail: { [weak self] error in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            wSelf.view.makeToast(error?.localizedDescription)
        }
    }
    
}
