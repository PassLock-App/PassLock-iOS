//
//  AddAccountPassViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/4/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import KakaFoundation
import CloudKit
import AppGroupKit
import Toast_Swift


class AddAccountPassViewController: SuperViewController {
    
    deinit {
        debugPrint("### AddAccountPassViewController ###")
    }
    
    init(_ model: PrivateBaseItemModel?) {
        self.model = model
        self.originalModel = model
        self.isEditVC = model != nil
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        self.title = StorageItemType.password.nameStr()
        if !self.isEditVC {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonClick))
        }
        
        let title = self.isEditVC ? "Update".localStr() : "Save".localStr()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(saveButtonClick))
        
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = self.view.bounds
        headView.size = CGSize(width: self.view.width, height: 140.ckValue())
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
                
        self.preloadModeldata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkFreeItemCount()
    }
    
    
    @objc func cancelBarButtonClick() {
        if self.isEditVC {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.checkLocalAsset()
            (self.navigationController ?? self).dismiss(animated: true)
        }
    }
    
    // MARK: 🌹 GET && SET 🌹
    
        
    lazy var dataArray: [AddItemCellModel] = {
        let model1 = AddItemCellModel(group: .titleGroup, headTitle: nil, itemArray: [.customTitle], footTitle: nil)
        let model2 = AddItemCellModel(group: .passwordGroup, headTitle: "Account".localStr(), itemArray: [.userName, .password, .website], footTitle: nil)
        let model3 = AddItemCellModel(group: .notesGroup, headTitle: "Notes (optional)".localStr(), itemArray: [.notes], footTitle: nil)
        let model4 = AddItemCellModel(group: .attachGroup, headTitle: "Attachments (optional)".localStr(), itemArray: [.attachs], footTitle: nil)
        
        return [model1, model2, model3, model4]
    }()
    
    var photoArray: [SingleFileModel?] {
        get {
            return self.model?.tempAssetArray ?? []
        }
    }
    
    func notesPlaceholder() -> String {
        let message1 = "Anything else you want, such as:".localStr()
        let message2 = "1. Associated accounts".localStr()
        let message3 = "2. Service password".localStr()
        let message4 = "3. Security question...".localStr()
        let message = message1 + "\r" + message2 + "\r" + message3 + "\r" + message4
        
        return message
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(AddCustomTitleTableCell.self, forCellReuseIdentifier: "AddCustomTitleTableCell")
        view.register(AddUserNameTableCell.self, forCellReuseIdentifier: "AddUserNameTableCell")
        view.register(AddPasswordTableCell.self, forCellReuseIdentifier: "AddPasswordTableCell")
        view.register(AddWebsiteTableCell.self, forCellReuseIdentifier: "AddWebsiteTableCell")
        view.register(AddNotesTableCell.self, forCellReuseIdentifier: "AddNotesTableCell")
        view.register(AddAttachTableCell.self, forCellReuseIdentifier: "AddAttachTableCell")
        view.register(AttachPlusViewCell.self, forCellReuseIdentifier: "AttachPlusViewCell")
        return view
    }()
    
    lazy var headView: AddPrivateItemHeadView = {
        let view = AddPrivateItemHeadView(frame: CGRectMake(0, 0, self.view.width, 140.ckValue()))
        view.model = self.model
        return view
    }()
    
}

extension AddAccountPassViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupModel = dataArray[section]
        return groupModel.group == .attachGroup ? photoArray.count + 1 : groupModel.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = dataArray[indexPath.section]
        
        if groupModel.group == .attachGroup {
            if indexPath.row == photoArray.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AttachPlusViewCell", for: indexPath) as! AttachPlusViewCell
                cell.update()
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddAttachTableCell", for: indexPath) as! AddAttachTableCell
                cell.update(itemModel: self.model, fileModel: photoArray[indexPath.row], index: indexPath.row + 1)
                return cell
            }
        }else{
            let itemType = groupModel.itemArray[indexPath.row]
            
            if groupModel.group == .titleGroup {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCustomTitleTableCell", for: indexPath) as! AddCustomTitleTableCell
                cell.model = self.model
                cell.delegate = self
                cell.updatePlaceholder("Name: e.g. VPN, chatGPT".localStr())
                return cell
            }else if itemType == .userName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddUserNameTableCell", for: indexPath) as! AddUserNameTableCell
                cell.model = self.model
                cell.delegate = self
                return cell
            }else if itemType == .password {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddPasswordTableCell", for: indexPath) as! AddPasswordTableCell
                cell.model = self.model
                cell.delegate = self
                return cell
            }else if itemType == .notes {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNotesTableCell", for: indexPath) as! AddNotesTableCell
                cell.model = self.model
                cell.delegate = self
                
                cell.updatePlaceholder(self.notesPlaceholder())
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddWebsiteTableCell", for: indexPath) as! AddWebsiteTableCell
                cell.model = self.model
                cell.delegate = self
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let groupModel = dataArray[indexPath.section]
        
        if groupModel.group == .attachGroup {
            if photoArray.count == indexPath.row {
                self.showSelectAttachPicker()
            }else{
                self.attachTableCellClick(indexPath)
            }
            return
        }
        
        let itemType = groupModel.itemArray[indexPath.row]
        
        if itemType == .password {
            let passVC = PassCreaterViewController()
            passVC.onCopyCallBack = { [weak self] (password) in
                self?.addOneNewPassword(password)
                self?.guideGotoModifyPassword(password)
                self?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(passVC, animated: true)
        }
        
        if itemType == .website {
            let webVC = SearchWebViewController()
            webVC.onSelectCallBack = { [weak self] (model) in
                self?.model?.passwordModel?.websiteModel = model
                self?.tableView.reloadData()
                self?.headView.model = self?.model
            }
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let groupModel = dataArray[indexPath.section]
        if groupModel.group == .attachGroup {
            return indexPath.row == photoArray.count ? 60.ckValue() : 90.ckValue()
        }else{
            let itemType = groupModel.itemArray[indexPath.row]
            if itemType == .notes {
                return 100.ckValue()
            }else{
                return 50.ckValue()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let groupModel = dataArray[indexPath.section]
        if groupModel.group == .attachGroup && indexPath.row < photoArray.count {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, finish) in
            self?.deleteAttachAction(indexPath.row)
        }
        action1.image = Reasource.systemNamed("trash", color: .white)
        
        action1.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [action1])
    }
    
}
