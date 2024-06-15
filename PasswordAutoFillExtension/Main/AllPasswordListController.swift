//
//  AllPasswordListController.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2024/6/6.
//

import KakaFoundation
import AppGroupKit

protocol AllPasswordListControllerDelegate: AnyObject {
    func passwordControllerDidDismiss(controller: AllPasswordListController)
    
    func passwordControllerDidSelect(controller: AllPasswordListController, account: String, passModel: PasswordListModel)
}

class AllPasswordListController: UIViewController {
    
    init(_ dominArray: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.dominArray = dominArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
        
    }
    
    private func preSetupHandleBuness() {
        self.view.backgroundColor = .random()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction))
        self.title = "PassLock Extension".localStr()
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.checkScreenPasscode()
        
        self.refreshDataAction()
        
    }
    
    func checkScreenPasscode() {
        guard ScreenLockManager.shared.checkNeedsShowScreenLock() else {
            return
        }
        
        let screenVC = PasscodeVerifyViewController(false)
        screenVC.onRightCallBack = { () in
            
        }
        screenVC.onCancelCallBack = { [weak self] () in
            guard let wSelf = self else { return }
            wSelf.delegate?.passwordControllerDidDismiss(controller: wSelf)
        }
        let navVC = UINavigationController(rootViewController: screenVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: false, completion: nil)
    }
    
    @objc func dismissAction() {
        self.delegate?.passwordControllerDidDismiss(controller: self)
    }
    
    // MARK:  GET && SET
    public weak var delegate: AllPasswordListControllerDelegate?
    
    lazy var originDataArray: [PrivateBaseItemModel] = {
        return [PrivateBaseItemModel]()
    }()
    
    lazy var dominArray: [String] = {
        return [String]()
    }()
    
    public var dataDictionary: [String: [PrivateBaseItemModel]] = [:]
    
    public var indexArray: [String] = [String]()
    
    public func dataArray(_ index: Int) -> [PrivateBaseItemModel] {
        let key = self.indexArray[index]
        let dataArr = self.dataDictionary[key] ?? []
        return dataArr
    }
    
    // MARK:  Lazy Init
    
    lazy var sharedUD: UserDefaults
        
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(PassbookTableExtensionCell.self, forCellReuseIdentifier: "PassbookTableExtensionCell")
        return view
    }()
    
    lazy var searchController: SearchListExtensionController = {
        let controller = SearchListExtensionController()
        controller.searchBar.delegate = self
        controller.onSelectCallBack = { [weak self] (model) in
            guard let wSelf = self else { return }
            
            if (model.passwordModel?.passwords?.count ?? 0) > 1 {
                let detialVC = PasswordDetialExtensionController(model: model)
                detialVC.onSelectCallBack = { [weak self] (account, model) in
                    guard let wSelf = self else { return }
                    
                    wSelf.delegate?.passwordControllerDidSelect(controller: wSelf, account: account, passModel: model)
                }
                wSelf.navigationController?.pushViewController(detialVC, animated: true)
            }else{
                guard let accountName = model.passwordModel?.accountName, let passwordModel = model.passwordModel?.passwords?.first else { return }

                wSelf.delegate?.passwordControllerDidSelect(controller: wSelf, account: accountName, passModel: passwordModel)
            }
            
        }
        return controller
    }()
    
}

extension AllPasswordListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint("searchText = \(searchText)")
        self.searchController.searchWithKey(searchText)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.cancelSearchAction()
    }
}
