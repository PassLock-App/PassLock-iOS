//
//  PasswordViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/3.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import KakaObjcKit
import MBProgressHUD

class PasswordViewController: SuperViewController {
    
    init(_ itemType: StorageItemType = StorageItemType.allItem) {
        self.itemType = itemType
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
        footView.size = CGSize(width: self.view.width, height: PasswordTableFootView.allHeight(maxWidth: self.view.width, status: viewModel.syncStatus))
        
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = kaka_IsiPhone() ? KakaTabbarItem.passwords.formatStr() : self.itemType.nameStr()
        
        if kaka_IsiPhone() {
            self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
            self.navigationItem.titleView = self.passTypeView
        }
        
        self.navigationItem.rightBarButtonItems = self.rightBarButtonItems

        self.addNetworkStatus()
                
        self.configSearchBar()
        
        self.refreshDataAction()
    }
    
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "list.bullet")?.flippedImage(), menu: self.filterMenu)
        return item
    }()
    
    lazy var rightBarButtonItems: [UIBarButtonItem] = {
        if kaka_IsMacOS() {
            let item1 = UIBarButtonItem(title: "Privacy Report".localStr(), style: .done, target: self, action: #selector(morePrivacyClick))
            return [item1]
        }else{
            let item1 = UIBarButtonItem(image: UIImage(systemName: "hand.raised"), style: .done, target: self, action: #selector(morePrivacyClick))
            return [item1]
        }
    }()
    
    // MARK: 🌹 GET && SET 🌹
    
    var itemType = StorageItemType.allItem
    
    lazy var viewModel: PasswordViewModel = {
        return PasswordViewModel(itemType)
    }()
        
    // MARK: 🌹 Lazy init 🌹
    lazy var appstoreManager: KakaAppStoreManager = {
        return KakaAppStoreManager()
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        if kaka_IsMacOS() {
            view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }else{
            view.refreshControl = self.mj_header
        }
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.healthView
        view.tableFooterView = self.footView
        
        view.register(PassItemTableViewCell.self, forCellReuseIdentifier: "PassItemTableViewCell")
        view.register(EmptyAmazingTableCell.self, forCellReuseIdentifier: "EmptyAmazingTableCell")
        view.register(EmptyNewsEventTableCell.self, forCellReuseIdentifier: "EmptyNewsEventTableCell")
        view.register(EmptyPrivacyReportTableCell.self, forCellReuseIdentifier: "EmptyPrivacyReportTableCell")
        return view
    }()
    
    lazy var mj_header: UIRefreshControl = {
        let header = UIRefreshControl()
        header.addTarget(self, action: #selector(refreshDataAction), for: .valueChanged)
        return header
    }()
    
    lazy var searchController: SearchListViewController = {
        let searchVC = SearchListViewController()
        searchVC.viewModel = self.viewModel
        searchVC.searchBar.delegate = self
        searchVC.onSelectCallBack = { [weak self] (model) in
            self?.clickPrivateItem(model)
        }
        return searchVC
    }()
    
    lazy var healthView: PasswordHealthView = {
        let height = kaka_IsiPad() ? 450.0 : 220.ckValue()
        let view = PasswordHealthView(frame: CGRectMake(0, 0, self.view.width, height))
        view.delegate = self
        return view
    }()
    
    lazy var footView: PasswordTableFootView = {
        let view = PasswordTableFootView(frame: CGRectMake(0, 0, self.view.width, PasswordTableFootView.allHeight(maxWidth: self.view.width, status: .unScyn)))
        view.update(dataArray: viewModel.originDataArray, viewModel: viewModel)
        view.onClickCallBack = { [weak self] () in
            guard let wSelf = self else { return }
            let cloudVC = CloudConfigViewController(wSelf.viewModel)
            cloudVC.onRefreshCallBack = { [weak self] () in
                self?.refreshDataAction()
            }
            wSelf.navigationController?.pushViewController(cloudVC, animated: true)
        }
        return view
    }()
    
    lazy var passTypeView: PassVaultTypeView = {
        let view = PassVaultTypeView(frame: CGRectMake(0, 0, self.view.width * 0.6, 36.ckValue()))
        view.backView.addBlock(for: .touchUpInside) { [weak self] sender in
            let bookVC = SwitchPassViewController()
            bookVC.onSelectCallBack = { [weak self] (model) in
                self?.refreshDataAction()
            }
            self?.navigationController?.pushViewController(bookVC, animated: true)
        }
        return view
    }()
    
    lazy var filterMenu: UIMenu = {
        
        let storageArray: [StorageItemType] = [.allItem, .password, .photoVault, .secretNotes]
        var actionArray: [UIAction] = [UIAction]()
        
        for subItem in storageArray {
            let subMenu = UIAction(title: subItem.nameStr(), image: subItem.systemIconImage(), identifier: nil, discoverabilityTitle: nil, attributes: [], state: .off, handler: { [weak self] _ in
                AppLocalManager.shared.lastItemType = subItem
                
                if self?.viewModel.itemType == subItem { return }
                
                self?.viewModel.itemType = subItem
                self?.refreshDataAction()
            })
            
            actionArray.append(subMenu)
        }
                
        let menu = UIMenu(title: "", children: actionArray)
        return menu
    }()
    
}

