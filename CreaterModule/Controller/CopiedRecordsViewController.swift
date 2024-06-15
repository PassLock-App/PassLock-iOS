//
//  CopiedRecordsViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit
import MJRefresh
import AppGroupKit
import CloudKit
import NVActivityIndicatorView

class CopiedRecordsViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = "Copied records".localStr()
        
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = contentView.bounds
        headView.size = CGSizeMake(self.view.width, 180.ckValue())
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.refreshDataAction()
    }
    
    @objc func refreshDataAction() {
        self.kaka_header.beginRefreshing()
        AppICloudManager.shared.fetchCopiedPasslist(cursor: self.cursor) { models, cursor in
            if let cursor = cursor {
                self.cursor = cursor
                self.tableView.mj_footer = self.mj_footer
            }
            self.dataArray.removeAll()
            self.sortUserModels(models)
        } fail: { error in
            self.view.makeToast(error?.localizedDescription)
            self.tableView.mj_footer = nil
            self.loadingView.stopAnimating()
            self.mj_footer.endRefreshing()
            self.kaka_header.endRefreshing()
        }

    }
    
    @objc func loadMoreDataAction() {
        
        AppICloudManager.shared.fetchCopiedPasslist(cursor: self.cursor) { models, cursor in
            self.sortUserModels(models)
            if let cursor = cursor {
                self.cursor = cursor
            }
        } fail: { error in
            self.view.makeToast(error?.localizedDescription)
            self.tableView.mj_footer = nil
            self.loadingView.stopAnimating()
            self.mj_footer.endRefreshing()
            self.kaka_header.endRefreshing()
        }

    }
    
    func sortUserModels(_ models: [PasswordListModel]) {
        self.dataArray += models
        self.kaka_header.endRefreshing()
        self.loadingView.stopAnimating()
        self.mj_footer.endRefreshing()
        self.tableView.reloadData()
    }
    
    // MARK:  GET && SET
    
    var cursor: CKQueryOperation.Cursor?

    lazy var dataArray: [PasswordListModel] = {
        return [PasswordListModel]()
    }()
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        if !kaka_IsMacOS() {
            view.refreshControl = self.kaka_header
        }
        view.tableHeaderView = self.headView
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "PasswordListTableCell")
        return view
    }()
    
    lazy var loadingView: NVActivityIndicatorView = {
        let frame = CGRectMake(0, 0, 40.ckValue(), 40.ckValue())
        let view = NVActivityIndicatorView(frame: frame, type: .ballBeat, color: .label)
        return view
    }()
    
    lazy var kaka_header: UIRefreshControl = {
        let header = UIRefreshControl()
        header.addTarget(self, action: #selector(refreshDataAction), for: .valueChanged)
        return header
    }()
    
    lazy var mj_footer: MJRefreshBackNormalFooter = {
        let view = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreDataAction))
        view.loadingView?.color = UIColor.label
        view.stateLabel?.isHidden = true
        return view
    }()
    
    var passModel: PasswordListModel?
    
    lazy var headView: UIView = {
        var image: UIImage?
        if #available(iOS 15.0, *) {
            image = UIImage(systemName: "clock.badge.checkmark")
        }else{
            image = UIImage(systemName: "clock")
        }
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 180.ckValue()))
        view.backgroundColor = .clear
        let faceImgView = UIImageView(image: image)
        faceImgView.contentMode = .scaleAspectFit
        faceImgView.tintColor = appMainColor
        view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15.ckValue())
            make.size.equalTo(88.ckValue())
        }
        return view
    }()
}

extension CopiedRecordsViewController: UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordListTableCell", for: indexPath)
        let model = dataArray[indexPath.row]
        let imageSize = CGSizeMake(25.ckValue(), 25.ckValue())
        
        var cellConfig = UIListContentConfiguration.sidebarSubtitleCell()
        cellConfig.image = model.deviceType.iconImage()
        cellConfig.text = model.password
        cellConfig.secondaryText = model.formatCreateDate().dateString(ofStyle: .full)
        cellConfig.imageProperties.maximumSize = imageSize
        cellConfig.textProperties.color = UIColor.label
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArray[indexPath.row]
        self.passModel = model
        
        guard let userPassCell = tableView.cellForRow(at: indexPath) else { return }
        
        UIMenuController.shared.arrowDirection = .default
        UIMenuController.shared.menuItems = [UIMenuItem(title: "Copy".localStr(), action: #selector(copyPassword)), UIMenuItem(title: "Share".localStr(), action: #selector(airdropPassword))]
        UIMenuController.shared.showMenu(from: userPassCell.contentView, rect: userPassCell.contentView.bounds)
    }
    
    @objc func copyPassword() {
        guard let password = self.passModel?.password else { return }
        
        UIPasteboard.general.string = password
        self.view.makeToast("Copied Successful".localStr())
    }
    
    @objc func airdropPassword() {
        guard let password = self.passModel?.password else { return }
        
        let shareVC = UIActivityViewController(activityItems: [password], applicationActivities: nil)
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
