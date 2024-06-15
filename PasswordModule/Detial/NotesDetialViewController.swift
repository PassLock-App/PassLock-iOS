//
//  NotesDetialViewController.swift
//  PassLock
//
//  Created by Melo on 2024/1/10.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD

class NotesDetialViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
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
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = StorageItemType.secretNotes.nameStr()

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
        
        let model1 = BaseItemGroupCellModel(group: .iconGroup, headTitle: nil, itemArray: [.icontitle], footTitle: nil)
        let model2 = BaseItemGroupCellModel(group: .notesGroup, headTitle: "Notes".localStr(), itemArray: [.otherNote], footTitle: nil)
        let model3 = BaseItemGroupCellModel(group: .actionGroup, headTitle: "More".localStr(), itemArray: [.syncAction , .starAction, .deleteAction], footTitle: dateTimeStr)
        
        self.dataArray.append(model1)
        self.dataArray.append(model2)
        self.dataArray.append(model3)
        
        self.tableView.reloadData()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel!
    
    var onSaveCallBack: ((PrivateBaseItemModel)->Void)?
        
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(DetialItemTitleViewCell.self, forCellReuseIdentifier: "DetialItemTitleViewCell")
        view.register(DetialItemNotesViewCell.self, forCellReuseIdentifier: "DetialItemNotesViewCell")
        view.register(DetialItemActionViewCell.self, forCellReuseIdentifier: "DetialItemActionViewCell")
        return view
    }()
    
    lazy var dataArray: [BaseItemGroupCellModel] = {
        return [BaseItemGroupCellModel]()
    }()
    
    lazy var moreMenu: UIMenu = {
        
        let editMenu = UIAction(title: "Edit".localStr(), image: UIImage(systemName: "highlighter"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { [weak self] _ in
            self?.editButtonClick()
        })
        
        let shareMenu = UIAction(title: "Share".localStr(), image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { [weak self] _ in
            self?.shareAction()
        })
                
        let menu = UIMenu(title: "", children: [editMenu, shareMenu])
        return menu
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = dataArray[indexPath.section]
        let itemType = groupModel.itemArray[indexPath.row]
        
        if groupModel.group == .iconGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemTitleViewCell") as! DetialItemTitleViewCell
            cell.model = self.model
            return cell
        } else if groupModel.group == .notesGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemNotesViewCell") as! DetialItemNotesViewCell
            cell.model = self.model
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetialItemActionViewCell") as! DetialItemActionViewCell
            cell.updateItemType(model: self.model, itemType: itemType)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupModel = dataArray[indexPath.section]
        let itemType = groupModel.itemArray[indexPath.row]
        
        if groupModel.group == .notesGroup {
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

extension NotesDetialViewController: UIPopoverPresentationControllerDelegate {

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
    
    @objc func editButtonClick() {
        let editVC = AddPrivateNoteViewController(model)
        editVC.onSaveCallBack = { [weak self] (saveModel) in
            self?.model = saveModel
            self?.onSaveCallBack?(saveModel)
            self?.refreshDataAction()
        }
        self.navigationController?.pushViewController(editVC, animated: true)
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
    
    func shareAction() {
        let content = (self.model.customTitle ?? "") + "\r\r" + (self.model.notes ?? "")
        let shareVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        if !kaka_IsiPhone() {
            shareVC.preferredContentSize = CGSize(width: 500.ckValue(), height: 450.ckValue())
            shareVC.modalPresentationStyle = .popover
            
            let popVC = shareVC.popoverPresentationController
            popVC?.delegate = self
            popVC?.backgroundColor = UIColor.clear
            popVC?.permittedArrowDirections = .down
            popVC?.sourceRect = self.view.bounds
            popVC?.sourceView = self.contentView
        }
        self.present(shareVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
