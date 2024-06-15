//
//  PasswordHistoryListController.swift
//  PassLock
//
//  Created by Melo on 2024/6/1.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordHistoryListController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
    
    init(_ passModel: PrivateBaseItemModel) {
        self.passModel = passModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = "All passwords".localStr()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
    }
    
    // MARK:  GET && SET
    var passModel: PrivateBaseItemModel!
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(PasswordHistoryListCell.self, forCellReuseIdentifier: "PasswordHistoryListCell")
        return view
    }()
    
    lazy var headView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 200.ckValue()))
        view.backgroundColor = .clear
        let faceImgView = UIImageView(image: Reasource.named("history_password"))
        faceImgView.contentMode = .scaleAspectFit
        view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10.ckValue())
            make.size.equalToSuperview()
        }
        return view
    }()
    
    lazy var dataArray: [PasswordListModel] = {
        return self.passModel.passwordModel?.passwords ?? []
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count > 1 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.dataArray.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordHistoryListCell", for: indexPath) as! PasswordHistoryListCell
            cell.update(model: self.dataArray.first, isCurrent: true)
            return cell
        }else{
            let passModel = self.dataArray[indexPath.row + 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordHistoryListCell", for: indexPath) as! PasswordHistoryListCell
            cell.update(model: passModel, isCurrent: false)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            UIPasteboard.general.string = self.dataArray.first?.password
            self.view.makeToast("Copied Successful".localStr())
        }else{
            UIPasteboard.general.string = self.dataArray[indexPath.row + 1].password
            self.view.makeToast("Copied Successful".localStr())
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : self.title
    }
    
}

