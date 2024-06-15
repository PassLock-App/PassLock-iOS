//
//  AddPrivateFileViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/4/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import CloudKit

class AddPrivateFileViewController: SuperViewController {
    
    deinit {
        debugPrint("### AddPrivateFileViewController ###")
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
        
        self.title = StorageItemType.photoVault.nameStr()
        
        if !self.isEditVC {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonClick))
        }

        let title = self.isEditVC ? "Update".localStr() : "Save".localStr()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(saveButtonClick))
        
        contentView.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
        headView.size = CGSizeMake(self.view.width, 150.ckValue())
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
    var model: PrivateBaseItemModel?
    
    var originalModel: PrivateBaseItemModel?
    
    
    var onSaveCallBack: ((PrivateBaseItemModel)->Void)?
    
    var isEditVC: Bool = false
    
        
    var photoArray: [SingleFileModel?] {
        get {
            return self.model?.tempAssetArray ?? []
        }
    }
    
    func notesPlaceholder() -> String {
        
        return "Others".localStr()
    }
    
    lazy var dataArray: [AddItemCellModel] = {
        let model1 = AddItemCellModel(group: .titleGroup, headTitle: nil, itemArray: [.customTitle], footTitle: nil)
        let model2 = AddItemCellModel(group: .notesGroup, headTitle: "Notes (optional)".localStr(), itemArray: [.notes], footTitle: nil)
        let model3 = AddItemCellModel(group: .attachGroup, headTitle: "Attachments".localStr(), itemArray: [.attachs], footTitle: nil)
        
        return [model1, model2, model3]
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(AddCustomTitleTableCell.self, forCellReuseIdentifier: "AddCustomTitleTableCell")
        view.register(AddNotesTableCell.self, forCellReuseIdentifier: "AddNotesTableCell")
        view.register(AddAttachTableCell.self, forCellReuseIdentifier: "AddAttachTableCell")
        view.register(AttachPlusViewCell.self, forCellReuseIdentifier: "AttachPlusViewCell")
        return view
    }()
    
    lazy var headView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 150.ckValue()))
        view.backgroundColor = .clear
        let iconView = UIImageView(image: Reasource.systemNamed("lock.doc", color: appMainColor))
        iconView.contentMode = .scaleAspectFit
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(80.ckValue())
        }
        return view
    }()
}


extension AddPrivateFileViewController: UITableViewDataSource, UITableViewDelegate {
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
            
            if groupModel.group == .titleGroup {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCustomTitleTableCell", for: indexPath) as! AddCustomTitleTableCell
                cell.model = self.model
                cell.delegate = self
                cell.updatePlaceholder("e.g. ID cards, paper contracts, private photos".localStr())
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNotesTableCell", for: indexPath) as! AddNotesTableCell
                cell.model = self.model
                cell.delegate = self
                
                cell.updatePlaceholder(self.notesPlaceholder())
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
