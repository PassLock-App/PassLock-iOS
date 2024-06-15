//
//  CloudConfigViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class CloudConfigViewController: SuperViewController {
    
    init(_ viewModel: PasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
        contentView.addSubview(buyBackView)
        buyBackView.addSubview(purchaseButton)
        buyBackView.addSubview(lineView)
        buyBackView.addSubview(tipsLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let isX = kaka_safeAreaInsets().bottom > 10
        var height = isX ? kaka_safeAreaInsets().bottom + 50.ckValue() : (kaka_IsMacOS() ? 80.ckValue() : 60.ckValue())
        
        buyBackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5.ckValue())
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20.ckValue())
            make.height.equalTo(44.ckValue())
            if kaka_IsMacOS() {
                make.centerY.equalToSuperview().offset(-10.ckValue())
            }else{
                make.top.equalTo(isX ? 10.ckValue() : 8.ckValue())
            }
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.greaterThanOrEqualTo(0)
            make.top.equalTo(purchaseButton.snp.bottom).offset(8.ckValue())
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(buyBackView.snp.top)
        }
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = "CloudStorage".localStr()
                
        self.refreshDataAction()
                                
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: KakaTabbarItem.developer.formatStr(), style: .done, target: self, action: #selector(openSourceBarClick))
    }
    
    
    @objc func syncConfigChanged() {
        self.syncModel = CloudSyncManager.shared.readSyncConfig()
        self.tableView.reloadData()
    }
    
    func updateGroupData() {

        var groupStr = String(format: "You have %@ items that have not been sync to the iCloud".localStr(), "\(localArray.count)")
        if localArray.count == viewModel.originDataArray.count {
            groupStr = "All data is local".localStr()
        }
        
        if localArray.count == 0 && remoteArray.count > 0 {
            groupStr = "Great, all data is backed up!".localStr()
        }
        
        if localArray.count + remoteArray.count == 0 {
            groupStr = "No data available".localStr()
        }
        
        let group1 = CloudGroupCellModel(group: .syncGroup, headTitle: groupStr, itemArray: [.syncLoclItem, .deleteCloudItem, .passwordExtension], footTitle: "")
        let group2 = CloudGroupCellModel(group: .saveGroup, headTitle: "After importing".localStr(), itemArray: configArray, footTitle: nil)
        let group3 = CloudGroupCellModel(group: .premiumGroup, headTitle: "About Premium".localStr(), itemArray: [], footTitle: nil)
        self.dataArray = [group1, group2, group3]
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        self.setNormalButtonTitle()
        
    }
    
    @objc func refreshDataAction() {
        
        let curPassbook = AppICloudManager.shared.currentPassbook
        self.viewModel.originDataArray = SandboxFileManager.shared.readPrivateItemModels(recordType: curPassbook.recordType, itemType: viewModel.itemType)
                
        self.localArray = viewModel.originDataArray.filter { !$0.isSyncCloud }
        self.remoteArray = viewModel.originDataArray.filter { $0.isSyncCloud }
        
        self.headView.updateCloudType(clouds: remoteArray.count, locals: localArray.count)
        
        self.updateGroupData()
    }
    
    @objc func openSourceBarClick() {
        let developVC = TransparencyViewController()
        self.navigationController?.pushViewController(developVC, animated: true)
    }
    
    // MARK:  GET && SET
    weak var viewModel: PasswordViewModel!
    
    var syncModel = CloudSyncManager.shared.readSyncConfig()
    
    var localArray: [PrivateBaseItemModel] = []
    
    var remoteArray: [PrivateBaseItemModel] = []
    
    var onRefreshCallBack: (()->Void)?
    
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 50.ckValue()
        view.tableHeaderView = self.headView
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: additionalSafeAreaInsets.bottom + 30.ckValue(), right: 0)
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(CloudSyncViewCell.self, forCellReuseIdentifier: "CloudSyncViewCell")
        view.register(SyncCloudButtonCell.self, forCellReuseIdentifier: "SyncCloudButtonCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "PremiumBenefitsCell")
        return view
    }()
    
    lazy var headView: CloudSyncHeadView = {
        let view = CloudSyncHeadView(frame: CGRectMake(0, 0, self.view.width, 200.ckValue()))
        return view
    }()
    
    lazy var buyBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.text = "The one-time purchase price will soon return to the original price".localStr()
        view.font = UIFontLight(10.ckValue())
        view.textColor = UIColor.secondaryLabel
        view.textAlignment = .center
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    lazy var purchaseButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = appMainColor
        view.setTitleColor(.white, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.ckValue()
        view.titleLabel?.font = UIFontBold(15.ckValue())
        view.addTarget(self, action: #selector(payButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var dataArray: [CloudGroupCellModel] = {
        return [CloudGroupCellModel]()
    }()
    
    lazy var configArray: [CloudCellItemType] = {
        let view: [CloudCellItemType] = [.autoSyncCloud, .compressImage, .autoDeleteTips]
        return view
    }()
    
    lazy var benefitArray: [PremiumBenefitsModel] = {
        return [.syncCloud, .unLimitSpace, .importAsset, .syncInApple, .changeLogos, .moreVaults, .darkweb, .removeAllAds, .newMore]
    }()

}

extension CloudConfigViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = dataArray[section].group
        return group == .premiumGroup ? benefitArray.count : dataArray[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = dataArray[indexPath.section].group

        if group == .syncGroup {
            let item = dataArray[indexPath.section].itemArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SyncCloudButtonCell") as! SyncCloudButtonCell
            
            cell.update(itemType: item, count: item == .syncLoclItem ? localArray.count : remoteArray.count)
            return cell
        }else if group == .saveGroup {
            let item = dataArray[indexPath.section].itemArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CloudSyncViewCell") as! CloudSyncViewCell
            cell.update(cellType: item, config: self.syncModel)
            cell.onCallBack = { [weak self] (model, curItem) in
                guard let wSelf = self else { return }
                wSelf.syncModel = model
                for index in 0..<wSelf.configArray.count {
                    guard let subCell = wSelf.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? CloudSyncViewCell else { return }
                    subCell.syncModel = model
                }
            }
            
            return cell
        }else{
            let benefits = benefitArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumBenefitsCell", for: indexPath)
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.text = benefits.titleStr()
            cellConfig.secondaryText = benefits.descStr()
            cellConfig.imageProperties.cornerRadius = 5.ckValue()
            cellConfig.imageProperties.maximumSize = CGSize(width: 32.ckValue(), height: 32.ckValue())
            cellConfig.image = benefits.iconImage()
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            
            cell.contentConfiguration = cellConfig
            cell.accessoryType = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = dataArray[indexPath.section]
        if cellModel.group == .syncGroup {
            
            let itemType = cellModel.itemArray[indexPath.row]
            
            if localArray.count + remoteArray.count == 0 {
                self.view.makeToast("No data available".localStr())
                return
            }
            
            if itemType == .syncLoclItem {
                
                
                if localArray.count == 0 && remoteArray.count > 0 {
                    self.view.makeToast("Great, all data is backed up!".localStr())
                    return
                }
                
                let selectVC = SelectItemsViewController(dataArray: localArray, isLocalItems: true)
                selectVC.onRefreshCallBack = { [weak self] () in
                    self?.onRefreshCallBack?()
                    self?.refreshDataAction()
                }
                self.navigationController?.pushViewController(selectVC, animated: true)
            }
            
            if itemType == .deleteCloudItem {
                
                if remoteArray.count == 0 && localArray.count > 0 {
                    self.view.makeToast("All data is local".localStr())
                    return
                }
                
                let selectVC = SelectItemsViewController(dataArray: remoteArray, isLocalItems: false)
                selectVC.onRefreshCallBack = { [weak self] () in
                    self?.onRefreshCallBack?()
                    self?.refreshDataAction()
                }
                self.navigationController?.pushViewController(selectVC, animated: true)
            }
            
            if itemType == .passwordExtension {
                let extensionVC = AutofillPassViewController()
                self.navigationController?.pushViewController(extensionVC, animated: true)
            }
        }
        
        if cellModel.group == .saveGroup {
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = dataArray[indexPath.section].group
        if group == .premiumGroup {
            return UITableView.automaticDimension
        }else{
            return UITableView.automaticDimension
        }
    }
    
    @objc func payButtonClick() {
        KakaAppStoreManager.presentPurcharseVC(self, animated: true)
    }
    
    func showGuidePremium() {
        let alertController = UIAlertController(title: "Tip".localStr(), message: "This is a premium feature, please upgrade to premium to unlock all premium features.".localStr(), preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Cancel".localStr(), style: .cancel) { (sender) in
            
        }
        let action2 = UIAlertAction(title: "Upgrade".localStr(), style: .destructive) { [weak self] (sender) in
            self?.payButtonClick()
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
}
