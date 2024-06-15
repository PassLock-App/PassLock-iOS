//
//  MacTabbarViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

protocol MacTabbarViewControllerDelegate: AnyObject {
    
    func macTabbarViewController(controller: MacTabbarViewController, otherType: MacTabbarCellItemType)
    
    func macTabbarViewControllerDidSelectUser(controller: MacTabbarViewController)
    
    func macTabbarViewControllerDidAddItem(controller: MacTabbarViewController, addCell: MacAddItemViewCell)
}


class MacTabbarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(userView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        debugPrint("MacTabbar = \(self.view.size)")
        
        userView.frame = CGRectMake(0, self.view.height - userHeight, self.view.width, userHeight)
        tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - userHeight)
        tableView.reloadData()
    }
    
    private func preSetupHandleBuness() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDataAction), name: NSNotification.Name(rawValue: kPostUserInfoChangedKey), object: nil)
        
        self.appearanceChanged()
    }
    
    @objc func refreshDataAction() {
        self.userView.update()
        self.tableView.reloadData()
    }
    
    @objc func appearanceChanged() {
        self.view.backgroundColor = kaka_IsMacOS() ? UIColor.clear : UIColor.systemBackground
        self.overrideUserInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.setNeedsStatusBarAppearanceUpdate()
        
//        self.view.backgroundColor = UIColor.rgb(33, 35, 36)
//        self.overrideUserInterfaceStyle = .dark
//        self.tableView.overrideUserInterfaceStyle = .dark
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let _ = noti.object as? UIColor else { return }
        self.tableView.reloadData()
    }
    
    // MARK:  GET && SET
    
    let userHeight = 75.ckValue()
    
    lazy var dataArray: [MacTabbarCellModel] = {
        let group1 = MacTabbarCellModel(group: .vaultGroup, headTitle: nil, itemArray: [.currentvault], footTitle: nil)
        let group2 = MacTabbarCellModel(group: .itemTypeGroup, headTitle: "Category".localStr(), itemArray: [.allItems, .loginItems, .fileItems, .noteItems], footTitle: nil)
        let group3 = MacTabbarCellModel(group: .otherGroup, headTitle: "Others".localStr(), itemArray: [.strongPass, .transparency, .downloadIOS, .addItems], footTitle: nil)
        return [group1, group2, group3]
    }()
    
    var selectIndexPath = IndexPath(row: -1, section: -1)
    
    weak var delegate: MacTabbarViewControllerDelegate?
    
    // MARK:  Lazy Init
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.selectionFollowsFocus = false
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: kaka_IsMacOS() ? 10 : kStatusBarHeight, left: 0, bottom: 0, right: 0)
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = false
        view.showsHorizontalScrollIndicator = false
        view.register(MacCurrentVaultTableCell.self, forCellReuseIdentifier: "MacCurrentVaultTableCell")
        view.register(MacTabItemViewCell.self, forCellReuseIdentifier: "MacTabItemViewCell")
        view.register(MacAddItemViewCell.self, forCellReuseIdentifier: "MacAddItemViewCell")
        return view
    }()
    
    lazy var userView: MacUserInfoView = {
        let view = MacUserInfoView(frame: CGRectMake(0, self.view.height - self.userHeight, self.view.width, userHeight))
        view.onClickCallBack = { [weak self] () in
            guard let wSelf = self else { return }
            wSelf.selectIndexPath = IndexPath(row: -1, section: -1)
            wSelf.tableView.reloadData()
            wSelf.delegate?.macTabbarViewControllerDidSelectUser(controller: wSelf)
        }
        return view
    }()
    
}

extension MacTabbarViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellModel = dataArray[section]
        return cellModel.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cellModel = dataArray[indexPath.section]
        let itemType = cellModel.itemArray[indexPath.row]
        let isSelected = self.selectIndexPath == indexPath
        
        if cellModel.group == .vaultGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MacCurrentVaultTableCell", for: indexPath) as! MacCurrentVaultTableCell
            cell.update()
            return cell
        } else {
            if itemType == .addItems {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacAddItemViewCell", for: indexPath) as! MacAddItemViewCell
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MacTabItemViewCell", for: indexPath) as! MacTabItemViewCell
                cell.itemType = itemType
                cell.isSelect = isSelected
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectIndexPath == indexPath { return }
                
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellModel = dataArray[indexPath.section]
        let itemType = cellModel.itemArray[indexPath.row]
        
        if itemType == .addItems {
            if let addCell = tableView.cellForRow(at: indexPath) as? MacAddItemViewCell {
                self.delegate?.macTabbarViewControllerDidAddItem(controller: self, addCell: addCell)
            }
            return
        }
        
        if itemType == .downloadIOS || itemType == .currentvault {
            self.delegate?.macTabbarViewController(controller: self, otherType: itemType)
            return
        }
        
        self.userView.isSelect = false
        
        self.delegate?.macTabbarViewController(controller: self, otherType: itemType)
        self.selectIndexPath = indexPath
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = dataArray[indexPath.section]
        let itemType = cellModel.itemArray[indexPath.row]

        if cellModel.group == .vaultGroup {
            return 60.ckValue()
        } else{
            return itemType == .addItems ? 80.ckValue() : 45.ckValue()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cellModel = dataArray[section]
        return cellModel.headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let cellModel = dataArray[section]
        return cellModel.footTitle
    }
    
}

