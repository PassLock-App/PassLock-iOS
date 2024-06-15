//
//  PasswordDetialViewController.swift
//  PassLock
//
//  Created by Melo on 2023/10/7.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD
import SafariServices
import KakaPhotoBrowser

class PasswordDetialViewController: SuperViewController {
    
    deinit {
        debugPrint("### PasswordDetialViewController ###")
    }
    
    init(model: PrivateBaseItemModel, healthArray: [PassHealthRick]) {
        self.model = model
        self.healthArray = healthArray
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
        tableView.frame = contentView.bounds
        
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.title = "Account Details".localStr()
    
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Reasource.systemNamed("ellipsis.circle", color: appMainColor), menu: self.moreMenu)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit".localStr(), style: .done, target: self, action: #selector(editButtonClick))
        
        self.refreshDataAction()
    }
    
    func refreshDataAction() {
        self.dataArray.removeAll()
        
        let isWebsite = self.model.passwordModel?.websiteModel?.dominUrlStr() != nil
        let healthLevel = self.healthArray.first ?? .allData
        
        var levelDesc: String = ""
        if let createDate = self.model.createDate {
            let createDate = Date(timeIntervalSince1970: createDate.rounded())
            let dateStr = createDate.dateString(ofStyle: .full)
            levelDesc.append("First created time:".localStr() + dateStr)
            levelDesc.append("\r")
        }
        
        let level = self.model.isSyncCloud ? healthLevel.reasonStr() : "The account is only stored locally and can be deleted by mistake at any time, please synchronize to iCloud.".localStr()
        levelDesc.append(level)
        
        
        let model0 = BaseItemGroupCellModel(group: .iconGroup, headTitle: nil, itemArray: [.icontitle], footTitle: nil)
        let model1 = BaseItemGroupCellModel(group: .basicGroup, headTitle: nil, itemArray: [.userName, .password, .darkweb], footTitle: "Once copy the username, you can detect if the account is being sold on the Dark Web. If yes, you should change the password immediately.".localStr())
        let model2 = BaseItemGroupCellModel(group: .websiteGroup, headTitle: nil, itemArray: [.websiteURL, .websiteModify], footTitle: isWebsite ? nil : "Website can be used to auto-fill passwords and load icons".localStr())
        let model3 = BaseItemGroupCellModel(group: .notesGroup, headTitle: nil, itemArray: [.otherNote], footTitle: nil)
        let model4 = BaseItemGroupCellModel(group: .attachsGroup, headTitle: nil, itemArray: [.otherAttach], footTitle: nil)
        let model5 = BaseItemGroupCellModel(group: .actionGroup, headTitle: nil, itemArray: [.syncAction, .starAction, .deleteAction, .safeReport], footTitle: levelDesc)
        
        self.dataArray.append(model0)
        self.dataArray.append(model1)
        self.dataArray.append(model2)
        if let notes = self.model.notes?.removeSpace(), notes.count > 0 {
            self.dataArray.append(model3)
        }
        if let assetIdArray = self.model.assetIdArray, assetIdArray.count > 0 {
            self.dataArray.append(model4)
        }
        
        self.dataArray.append(model5)
        
        self.tableView.reloadData()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel!
    
    var healthArray: [PassHealthRick]!
    
    var onSaveCallBack: ((PrivateBaseItemModel)->Void)?
    
    var isVisiblePass: Bool = false
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var dataArray: [BaseItemGroupCellModel] = {
        return [BaseItemGroupCellModel]()
    }()
    
    var photoArray: [SingleFileModel?] {
        get {
            guard let assetIdArray = self.model.assetIdArray, assetIdArray.count > 0 else { return [] }
            var tempArray = [SingleFileModel?]()
            for index in 0..<assetIdArray.count {
                let recordID = assetIdArray[index]
                let subModel = SandboxFileManager.shared.readPassFileAsset(recordType: self.model.recordType, recordId: recordID)
                tempArray.append(subModel)
            }
            return tempArray
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(PasswordBasicViewCell.self, forCellReuseIdentifier: "PasswordBasicViewCell")
        view.register(PasswordUserPassCell.self, forCellReuseIdentifier: "PasswordUserPassCell")
        view.register(PasswordVaultTypeCell.self, forCellReuseIdentifier: "PasswordVaultTypeCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "DarkWebTableViewCell")
        view.register(PasswordWebsiteCell.self, forCellReuseIdentifier: "PasswordWebsiteCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "NotesTableViewCell")
        view.register(PasswordAttachTableCell.self, forCellReuseIdentifier: "PasswordAttachTableCell")
        view.register(PasswordSafeReportCell.self, forCellReuseIdentifier: "PasswordSafeReportCell")
        view.register(DetialItemActionViewCell.self, forCellReuseIdentifier: "DetialItemActionViewCell")
        return view
    }()
    
}

extension PasswordDetialViewController: UITableViewDataSource, UITableViewDelegate {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordBasicViewCell", for: indexPath) as! PasswordBasicViewCell
            cell.model = self.model
            return cell
        }else if groupModel.group == .basicGroup {
            let itemType = groupModel.itemArray[indexPath.row]
            if itemType == .userName || itemType == .password {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordUserPassCell", for: indexPath) as! PasswordUserPassCell
                cell.update(model: self.model, itemType: itemType, isVisible: self.isVisiblePass)
                return cell
            }else if itemType == .vaultType {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordVaultTypeCell", for: indexPath) as! PasswordVaultTypeCell
                cell.model = self.model
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DarkWebTableViewCell", for: indexPath)
                var cellConfig = UIListContentConfiguration.cell()
                cellConfig.text = "Is it pwned in dark web?".localStr()
                
                cellConfig.textProperties.font = UIFontLight(15.ckValue())
                cellConfig.textProperties.color = appMainColor
                
                cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
                cellConfig.imageToTextPadding = 15
                
                cell.accessoryType = .disclosureIndicator
                cell.contentConfiguration = cellConfig
                return cell
            }
        }else if groupModel.group == .websiteGroup {
            let itemType = groupModel.itemArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordWebsiteCell", for: indexPath) as! PasswordWebsiteCell
            cell.update(model: self.model, itemType: itemType)
            return cell
        }else if groupModel.group == .notesGroup {
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
            
        }else if groupModel.group == .attachsGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordAttachTableCell", for: indexPath) as! PasswordAttachTableCell
            cell.update(itemModel: self.model, fileModel: self.photoArray[indexPath.row], index: indexPath.row + 1)
            return cell
        }else{
            let itemType = groupModel.itemArray[indexPath.row]
            if itemType == .safeReport {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordSafeReportCell", for: indexPath) as! PasswordSafeReportCell
                cell.update(model: self.model, healths: self.healthArray)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemActionViewCell") as! DetialItemActionViewCell
                cell.updateItemType(model: self.model, itemType: itemType)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupModel = dataArray[indexPath.section]
        if groupModel.group == .attachsGroup {
            self.attachTableCellClick(indexPath)
            return
        }
        
        let itemType = groupModel.itemArray[indexPath.row]
        if itemType == .userName {
            UIPasteboard.general.string = self.model.passwordModel?.accountName
            self.view.makeToast("Copied Successful".localStr())
        }
        
        if itemType == .password {
            guard let userPassCell = tableView.cellForRow(at: indexPath) as? PasswordUserPassCell else { return }
            
            UIMenuController.shared.arrowDirection = .default
            UIMenuController.shared.menuItems = [UIMenuItem(title: "Copy".localStr(), action: #selector(copyPassword)), UIMenuItem(title: isVisiblePass ? "Hide".localStr() : "Visible".localStr(), action: #selector(visiblePassword)), UIMenuItem(title: "All passwords".localStr(), action: #selector(historyPassword))]
            UIMenuController.shared.showMenu(from: userPassCell.contentView, rect: userPassCell.contentView.bounds)
        }
        
        if itemType == .darkweb {
            self.scanForDarkWebsite()
        }
        
        if itemType == .websiteURL {
            guard let webStr = model.passwordModel?.websiteModel?.dominUrlStr(), let webURL = URL(string: webStr) else {
                let searchVC = SearchWebViewController()
                searchVC.onSelectCallBack = { [weak self] (webModel) in
                    self?.saveWebsiteInfo(webModel)
                }
                self.navigationController?.pushViewController(searchVC, animated: true)
                return
            }
            
            if kaka_IsMacOS() {
                UIApplication.shared.open(webURL)
            }else{
                let webVC = SFSafariViewController(url: webURL)
                webVC.preferredControlTintColor = appMainColor
                self.present(webVC, animated: true)
            }
        }
        
        if itemType == .websiteModify {
            guard let webStr = model.passwordModel?.websiteModel?.dominUrlStr(), let webURL = URL(string: webStr) else {
                return
            }
            
            UIApplication.shared.open(webURL)
        }
        
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

extension PasswordDetialViewController: UIPopoverPresentationControllerDelegate {
    
    @objc func copyPassword() {
        UIPasteboard.general.string = self.model.passwordModel?.passwords?.first?.password
        self.view.makeToast("Copied Successful".localStr())
    }
    
    @objc func visiblePassword() {
        self.isVisiblePass = !self.isVisiblePass
        self.tableView.reloadData()
    }
    
    @objc func historyPassword() {
        let historyVC = PasswordHistoryListController(self.model)
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func scanForDarkWebsite() {
       
        
        UIPasteboard.general.string = self.model.passwordModel?.accountName
        guard let vURL = URL(string: "https://haveibeenpwned.com/") else { return }
        if kaka_IsMacOS() {
            self.view.makeToast("Copied Successful".localStr())
            UIApplication.shared.open(vURL)
        }else{
            let webVC = SFSafariViewController(url: vURL)
            webVC.preferredControlTintColor = appMainColor
            webVC.view.makeToast("Copied Successful".localStr())
            self.present(webVC, animated: true)
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
    
    @objc func sharedButtonClick() {
        let accountName = "Username".localStr() + "\r" + (self.model.passwordModel?.accountName ?? "N/A")
        let password = "Password".localStr() + "\r" + (self.model.passwordModel?.passwords?.first?.password ?? "N/A")
        let notes = "Notes".localStr() + "\r" + (self.model.notes ?? "N/A")
        
        let shareMessage = accountName + "\r" + password + "\r" + notes
        
        let shareVC = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        if !kaka_IsiPhone() {
            shareVC.preferredContentSize = CGSize(width: 500.ckValue(), height: 450.ckValue())
            shareVC.modalPresentationStyle = .popover
            
            let popVC = shareVC.popoverPresentationController
            popVC?.delegate = self
            popVC?.backgroundColor = UIColor.clear
            popVC?.permittedArrowDirections = .down
            popVC?.sourceRect = self.view.bounds
            popVC?.sourceView = self.navigationController?.navigationBar ?? self.view
        }
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @objc func editButtonClick() {
        let editVC = AddAccountPassViewController(self.model)
        editVC.onSaveCallBack = { [weak self] (saveModel) in
            self?.model = saveModel
            self?.refreshDataAction()
            self?.onSaveCallBack?(saveModel)
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
            let action1 = UIAlertAction(title: "Cancel".localStr(), style: .cancel)
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
    
    func saveWebsiteInfo(_ webModel: WebsiteInfoModel) {
        self.model.passwordModel?.websiteModel = webModel
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.updateOnePrivateItem(model: self.model) { model in
            MBProgressHUD.hideLoading(self.view)
            self.model = model
            self.onSaveCallBack?(model)
            self.refreshDataAction()
        } fail: { error in
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
