//
//  SwitchPassViewController.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/10.
//

import KakaFoundation
import KakaUIKit
import MBProgressHUD
import AppGroupKit
import MarqueeLabel

class SwitchPassViewController: SuperViewController {
    
    deinit {
        debugPrint("### SwitchPassViewController ###")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = "Switch Vault".localStr()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = contentView.bounds
        
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.refreshDataAction()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] () in
            guard let wSelf = self else { return }
            let _ = wSelf.tableView(wSelf.tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 0))
        }
    
        if !kaka_IsiPhone() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonClick))
        }
    }
    
    @objc func closeButtonClick() {
        if self.isPresent() {
            self.navigationController?.dismiss(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    @objc func refreshDataAction() {
        self.dataArray = AppICloudManager.shared.getPassbooks()
        self.tableView.reloadData()
        
        self.mj_header.endRefreshing()
    }
    
    // MARK: 🌹 GET && SET 🌹
        
    lazy var dataArray: [AppRecordTypeModel] = {
        return [AppRecordTypeModel]()
    }()
    
    var onSelectCallBack: ((AppRecordTypeModel)->Void)?
    
    
    // MARK: 🌹 Lazy init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        if !kaka_IsMacOS() {
            view.refreshControl = self.mj_header
        }
        view.rowHeight = UITableView.automaticDimension
        view.register(UITableViewCell.self, forCellReuseIdentifier: "PassbookTableCell")
        view.tableHeaderView = self.headView
        return view
    }()
    
    lazy var headView: UIView = {
        let svgFilePath = Reasource.svgFileUrl("accept_privacy")
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 200.ckValue()))
        view.backgroundColor = .clear
        let faceImgView = UIImageView()
        faceImgView.sd_setImage(with: URL(fileURLWithPath: svgFilePath))
        faceImgView.contentMode = .scaleAspectFit
        view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10.ckValue())
            make.size.equalToSuperview()
        }
        return view
    }()
    
    lazy var mj_header: UIRefreshControl = {
        let header = UIRefreshControl()
        header.addTarget(self, action: #selector(refreshDataAction), for: .valueChanged)
        return header
    }()
}

extension SwitchPassViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassbookTableCell", for: indexPath)
        let model = dataArray[indexPath.section]
        let isSelect = model.recordType == AppICloudManager.shared.currentPassbook.recordType

        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.image = model.recordType.recordIconImage()
        cellConfig.imageProperties.maximumSize = CGSizeMake(30.ckValue(), 30.ckValue())
        cellConfig.text = model.showTitle()
        cellConfig.secondaryText = model.recordType.descStr()
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        if kaka_IsMacOS() {
            cellConfig.textProperties.font = UIFontLight(15.ckValue())
        }
        if isSelect {
            cell.accessoryView = self.selectImgView()
        }else{
            cell.accessoryView = nil
            cell.accessoryType = .disclosureIndicator
        }
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dataArray[indexPath.section].recordType == AppICloudManager.shared.currentPassbook.recordType {
            self.closeButtonClick()
            return
        }
        
        for index in dataArray.indices {
            dataArray[index].isSelected = false
        }
        
        var model = dataArray[indexPath.section]
        model.isSelected = true
        
        self.dataArray[indexPath.section] = model
        AppICloudManager.shared.updatePassbooks(dataArray)
        self.onSelectCallBack?(model)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kICloudPassBookChangedKey), object: nil)
        
        self.closeButtonClick()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                        
        let action1 = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, finish) in
            self?.setTopFirstClick(indexPath)
        }
        action1.image = Reasource.systemNamed("arrow.up", color: .white)
                
        let action2 = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, finish) in
            self?.editPassbookNameClick(indexPath)
        }
        action2.image = Reasource.systemNamed("pencil", color: .white)
        
        action1.backgroundColor = UIColor.red
        action2.backgroundColor = UIColor.systemBlue
        
        return UISwipeActionsConfiguration(actions: [action1, action2])
    }
    
    func proImgView() -> UIImageView {
        let view = UIImageView(image: Reasource.systemNamed("crown.fill"))
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }
    
    func selectImgView() -> UIImageView {
        let selectImage = Reasource.systemNamed("checkmark.circle.fill", color: appMainColor)
        let view = UIImageView(image: selectImage)
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }
    
    func unselectImgView() -> UIImageView {
        let normalImage = Reasource.systemNamed("circle", color: UIColor.label)
        let view = UIImageView(image: normalImage)
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }

}

extension SwitchPassViewController {
    
    func setTopFirstClick(_ indexPath: IndexPath) {
        
        let model = dataArray[indexPath.section]
        
        self.dataArray.remove(at: indexPath.section)
        self.dataArray.insert(model, at: 0)
        
        AppICloudManager.shared.updatePassbooks(dataArray)
        self.tableView.reloadData()
    }
    
    func editPassbookNameClick(_ indexPath: IndexPath) {
        
        let bookModel = dataArray[indexPath.section]
        
        let editAlertVC = UIAlertController(title: "Edit nickname".localStr(), message: nil, preferredStyle: .alert)
        editAlertVC.addTextField { textView in
            let placeText = bookModel.customName ?? bookModel.recordType.nameStr()
            let placeAttbute = NSAttributedString(string: placeText, attributes: [.font: UIFontLight(15.ckValue()), .foregroundColor: UIColor.placeholderText])
            textView.text = placeText
            textView.attributedPlaceholder = placeAttbute
            textView.clearButtonMode = .whileEditing
        }
        editAlertVC.addAction(UIAlertAction(title: "Cancel".localStr(), style: .cancel, handler: nil))
        editAlertVC.addAction(UIAlertAction(title: "Done".localStr(), style: .default, handler: { [weak self] action in
            guard let nameField = editAlertVC.textFields?.first, let nameText = nameField.text, nameText.count > 0 else {
                return
            }

            self?.updateNickName(nameStr: nameText, indexPath: indexPath)
        }))
        self.present(editAlertVC, animated: true)
    }
    
    func updateNickName(nameStr: String, indexPath: IndexPath) {
        
        var model = dataArray[indexPath.section]
        model.customName = nameStr
        
        dataArray[indexPath.section] = model
        
        AppICloudManager.shared.updatePassbooks(dataArray)
        self.tableView.reloadData()
        
        guard let selectModel = self.dataArray.filter({ $0.isSelected }).first else { return }
        self.onSelectCallBack?(selectModel)
    }
}
