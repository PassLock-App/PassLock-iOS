//
//  PasswordDetialExtensionController.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2023/11/30.
//

import KakaFoundation
import AppGroupKit
import SafariServices
import Toast_Swift


class PasswordDetialExtensionController: UIViewController {
    
    deinit {
        debugPrint("### PasswordDetialExtensionController ###")
    }
    
    init(model: PrivateBaseItemModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        
        self.view.addSubview(tableView)
    }
    
    private func preSetupContains() {
        
        tableView.frame = self.view.bounds
        
    }
    
    private func preSetupHandleBuness() {
        self.title = "Account Details".localStr()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClick))
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel!
    
    var onSelectCallBack: ((String, PasswordListModel)->Void)?
    
    lazy var dataArray: [BaseItemGroupCellModel] = {
        
        var dateTimeStr = ""
        if let createDate = self.model.createDate {
            let createDate = Date(timeIntervalSince1970: createDate.rounded())
            let dateStr = createDate.dateString(ofStyle: .full)
            dateTimeStr.append("First created time:".localStr() + dateStr)
        }
        
        let model1 = BaseItemGroupCellModel(group: .iconGroup, headTitle: nil, itemArray: [.icontitle], footTitle: nil)
        let model2 = BaseItemGroupCellModel(group: .basicGroup, headTitle: nil, itemArray: [.userName, .vaultType, .otherNote], footTitle: nil)
        let model3 = BaseItemGroupCellModel(group: .historyPassGroup, headTitle: "Select the password you want to fill".localStr(), itemArray: [.password], footTitle: dateTimeStr)
        
        return [model1, model2, model3]
    }()
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(PasswordBasicViewCell.self, forCellReuseIdentifier: "PasswordBasicViewCell")
        view.register(PasswordUserPassCell.self, forCellReuseIdentifier: "PasswordUserPassCell")
        view.register(PasswordVaultTypeCell.self, forCellReuseIdentifier: "PasswordVaultTypeCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "NotesTableViewCell")
        view.register(PasswordHistoryListCell.self, forCellReuseIdentifier: "PasswordHistoryListCell")
        return view
    }()
    
    @objc func closeButtonClick() {
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonClick() {
        guard let accountName = self.model.passwordModel?.accountName, let passwordModel = self.model.passwordModel?.passwords?.first else { return }

        self.onSelectCallBack?(accountName, passwordModel)
        self.dismiss(animated: true)
    }
}

extension PasswordDetialExtensionController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let groupModel = dataArray[section]
        return groupModel.group == .historyPassGroup ? (self.model.passwordModel?.passwords?.count ?? 0) : groupModel.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = dataArray[indexPath.section]
        if groupModel.group == .iconGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordBasicViewCell", for: indexPath) as! PasswordBasicViewCell
            cell.model = self.model
            return cell
        }else if groupModel.group == .basicGroup {
            let itemType = groupModel.itemArray[indexPath.row]
            if itemType == .userName {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordUserPassCell", for: indexPath) as! PasswordUserPassCell
                cell.update(model: self.model, itemType: itemType, isVisible: true)
                return cell
            }else if itemType == .vaultType {
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
        }else{
            let passModel = self.model.passwordModel?.passwords?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordHistoryListCell", for: indexPath) as! PasswordHistoryListCell
            cell.update(model: passModel, isCurrent: indexPath.row == 0)
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupModel = dataArray[indexPath.section]
        
        if groupModel.group == .historyPassGroup {
            guard let accountName = self.model.passwordModel?.accountName, let passwordModel = self.model.passwordModel?.passwords?[indexPath.row] else { return }
            self.onSelectCallBack?(accountName, passwordModel)
            self.dismiss(animated: true)
            return
        }
        
        let itemType = groupModel.itemArray[indexPath.row]
        
        if itemType == .userName {
            UIPasteboard.general.string = self.model.passwordModel?.accountName
            self.view.makeToast("Copied Successful".localStr())
        }
        
        if itemType == .otherNote {
            UIPasteboard.general.string = self.model.notes
            self.view.makeToast("Copied Successful".localStr())
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.dataArray[section].footTitle
    }
    
}
