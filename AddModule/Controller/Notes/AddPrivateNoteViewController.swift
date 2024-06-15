//
//  AddPrivateNoteViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/4/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import CloudKit


class AddPrivateNoteViewController: SuperViewController {
    
    deinit {
        debugPrint("### AddPrivateNoteViewController ###")
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
        self.title = StorageItemType.secretNotes.nameStr()
        
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
            (self.navigationController ?? self).dismiss(animated: true)
        }
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel?
    
    var originalModel: PrivateBaseItemModel?
    
    var onSaveCallBack: ((PrivateBaseItemModel)->Void)?
    
    var isEditVC: Bool = false
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(AddNoteTitleViewCell.self, forCellReuseIdentifier: "AddNoteTitleViewCell")
        view.register(AddNoteContentViewCell.self, forCellReuseIdentifier: "AddNoteContentViewCell")
        return view
    }()
    
    lazy var headView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 200.ckValue()))
        view.backgroundColor = .clear
        let iconView = UIImageView(image: StorageItemType.secretNotes.systemIconImage())
        iconView.contentMode = .scaleAspectFit
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(80.ckValue())
        }
        return view
    }()
    
}

extension AddPrivateNoteViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteTitleViewCell", for: indexPath) as! AddNoteTitleViewCell
            cell.model = self.model
            cell.onCallBack = { [weak self] (title) in
                self?.model?.customTitle = title
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNoteContentViewCell", for: indexPath) as! AddNoteContentViewCell
            cell.model = self.model
            cell.onCallBack = { [weak self] (content) in
                self?.model?.notes = content
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.ckValue()
        }else{
            return self.view.height - app_navHeight - 50.ckValue() - headView.height - 220.ckValue()
        }
    }
    
}
