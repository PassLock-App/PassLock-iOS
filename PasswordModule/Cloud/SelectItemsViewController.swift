//
//  SelectItemsViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import StoreKit
import MBProgressHUD

class SelectItemsViewController: SuperViewController {
    
    deinit {
        if !kaka_IsMacOS() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
    
    init(dataArray: [PrivateBaseItemModel], isLocalItems: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        let filterArray = dataArray.map {
            var subModel = $0
            subModel.isSelect = false
            return subModel
        }
        
        self.originDataArray = filterArray
        self.isLocalItems = isLocalItems
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
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.title = isLocalItems ? CloudCellItemType.syncLoclItem.titleStr() : CloudCellItemType.deleteCloudItem.titleStr()
        self.navigationItem.rightBarButtonItem = self.rightBarItem
        
        self.tableView.setEditing(true, animated: true)
        
        self.refreshDataAction()
        
        self.showOneAlert(title: "Tip".localStr(), message: isLocalItems ? "Please select the items you want to sync to iCloud".localStr() : "This operation only deletes the iCloud items, but keeps the local items.".localStr(), confirm: "OK".localStr()) {
        }
        
    }
    
    func refreshDataAction() {
                    
        ...
        
        self.indexArray = sortedDictory.map({ $0.key })
        
        self.dataDictionary = groupedDictionary
        
        self.tableView.reloadData()
    }
    
    // MARK:  GET && SET
    
    var onRefreshCallBack: (()->Void)?
    
    var isLocalItems: Bool!
    
    lazy var dataDictionary: [String: [PrivateBaseItemModel]] = {
        return [String: [PrivateBaseItemModel]]()
    }()
    
    public func dataArray(_ index: Int) -> [PrivateBaseItemModel] {
        let key = self.indexArray[index]
        let dataArr = self.dataDictionary[key] ?? []
        return dataArr
    }
    
    public var indexArray: [String] = [String]()

    var originDataArray: [PrivateBaseItemModel] = []
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        if kaka_IsMacOS() {
            view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.allowsMultipleSelection = true
        view.allowsMultipleSelectionDuringEditing = true
        view.register(PassItemTableViewCell.self, forCellReuseIdentifier: "PassItemTableViewCell")
        return view
    }()
    
    lazy var selectArray: [PrivateBaseItemModel] = {
        return [PrivateBaseItemModel]()
    }()
    
    lazy var rightBarItem: UIBarButtonItem = {
        if isLocalItems {
            let rightBarItem = UIBarButtonItem(title: "Sync".localStr(), style: .done, target: self, action: #selector(rightBarItemClick))
            return rightBarItem
        }else{
            let rightBarItem = UIBarButtonItem(title: "Delete".localStr(), style: .done, target: self, action: #selector(rightBarItemClick))
            return rightBarItem
        }
    }()
    
    @objc func rightBarItemClick() {
        if self.selectArray.count == 0 {
            self.tableView.kaka_playShakeAnim()
            return
        }
                
        if self.isLocalItems {
            self.syncItemsToCloud()
        }else{
            self.showTwoAlert(title: "Tip".localStr(), message: "This operation only deletes the iCloud items, but keeps the local items.".localStr(), confirm: "Delete".localStr()) {
                self.removeItemsFromCloud()
            }
        }
    }
    
    func syncItemsToCloud() {
        
        let remoteArray = self.selectArray.map {
            var remoteModel = $0
            remoteModel.isSyncCloud = true
            return remoteModel
        }
        
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.saveMultipleRecords(models: remoteArray) { models in
            
            MBProgressHUD.hideLoading(self.view)
            let modelRecordIds = Set(models.map { $0.recordId })
            let filteredArray = self.originDataArray.filter { !modelRecordIds.contains($0.recordId) }
            
            self.originDataArray = filteredArray
            self.refreshDataAction()
            self.onRefreshCallBack?()
            
            if filteredArray.count == 0 {
                self.showOneAlert(title: "Tip".localStr(), message: "Sync Successful".localStr(), confirm: "Done".localStr()) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.view.makeToast("Sync Successful".localStr())
            }
            
        } fail: { error in
            self.onRefreshCallBack?()
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }

    }
    
    func removeItemsFromCloud() {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.deleteMultipleRecords(models: selectArray, isDeleteLocal: false) { models in
            
            MBProgressHUD.hideLoading(self.view)
            let modelRecordIds = Set(models.map { $0.recordId })

            let filteredArray = self.originDataArray.filter { !modelRecordIds.contains($0.recordId) }
            
            self.originDataArray = filteredArray
            self.refreshDataAction()
            self.onRefreshCallBack?()
            
            if filteredArray.count == 0 {
                self.showOneAlert(title: "Tip".localStr(), message: "Delete Successful".localStr(), confirm: "Done".localStr()) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.view.makeToast("Delete Successful".localStr())
            }
            
        } fail: { error in
            self.onRefreshCallBack?()
            MBProgressHUD.hideLoading(self.view)
            self.view.makeToast(error?.localizedDescription)
        }
    }
}

extension SelectItemsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataArray = self.dataArray(section)
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataArray = self.dataArray(indexPath.section)
        let model = dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassItemTableViewCell", for: indexPath) as! PassItemTableViewCell
        cell.update(model: model, healthArray: [.securety])
        cell.setSelected(selectArray.contains(where: { $0.recordId == model.recordId }), animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ...
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        ...
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.indexArray[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.indexArray
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
