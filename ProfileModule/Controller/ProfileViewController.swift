//
//  ProfileViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/3.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import KakaObjcKit
import MBProgressHUD
import Toast_Swift
import LocalAuthentication
import StoreKit

class ProfileViewController: SuperViewController, UINavigationControllerDelegate {

    override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = KakaTabbarItem.profile.formatStr()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        tableView.frame = contentView.bounds
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        if kaka_IsiPhone() {
            self.navigationController?.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceChanged), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNoti), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func appearanceChanged() {
        super.appearanceChanged()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if kaka_IsiPhone() {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }else{
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        
        self.didBecomeActiveNoti()
    }
    
    @objc func didBecomeActiveNoti() {
        self.tableView.reloadData()
        self.appstoreManager.verifyPaymentRecords()
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    private var dataArray: [UserGroupCellModel] {
        get {
            var tempArray = [UserGroupCellModel]()
            
            let model1 = UserGroupCellModel(group: .accountGroup, headTitle: nil, itemArray: [.userInfo], footTitle: nil)
                        
            let model2 = UserGroupCellModel(group: .settingGroup, headTitle: "Preference".localStr(), itemArray: [.autofill, .autoLock, .toggleIcon], footTitle: nil)
            
            let model3 = UserGroupCellModel(group: .appearanceGroup, headTitle: "Theme".localStr(), itemArray: [.themeColor, .appearance], footTitle: nil)
            
            let model4 = UserGroupCellModel(group: .othersGroup, headTitle: "Others".localStr(), itemArray: [.share, .aboutUS], footTitle: nil)
            
            tempArray.append(model1)
            
            tempArray.append(model2)
            tempArray.append(model3)
            tempArray.append(model4)
            
            return tempArray
        }
    }
    
    lazy var appstoreManager: KakaAppStoreManager = {
        return KakaAppStoreManager()
    }()
    
    // MARK: 🌹 Lazy init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(UserBasicViewCell.self, forCellReuseIdentifier: "UserBasicViewCell")
        view.register(GuidePremiumViewCell.self, forCellReuseIdentifier: "GuidePremiumViewCell")
        view.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return view
    }()
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController is ProfileViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.section].itemArray[indexPath.row]
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserBasicViewCell", for: indexPath) as! UserBasicViewCell
            cell.update()
            cell.onClickAvatarCallBack = { [weak self] (userCell) in
                self?.clickAvatarTap(userCell)
            }
            cell.onClickNameCallBack = { [weak self] () in
                self?.editNameTap()
            }
            return cell
        }else{
            if item == .guideVIP {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GuidePremiumViewCell", for: indexPath) as! GuidePremiumViewCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
                cell.item = item
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataArray[indexPath.section].itemArray[indexPath.row]
        
        if item == .aboutUS {
            let aboutUS = PreferceViewController()
            self.navigationController?.pushViewController(aboutUS, animated: true)
        }
        
        if item == .toggleIcon {
            let logoVC = ToggleAppLogoViewController()
            self.navigationController?.pushViewController(logoVC, animated: true)
        }
        
        if item == .autoLock {
            let safeVC = SafetyViewController()
            self.navigationController?.pushViewController(safeVC, animated: true)
        }
        
        if item == .appearance && kaka_IsMacOS() {
            guard let vURL = URL(string: SystemSettingPath.appearance.settingPathStr()) else { return }
            UIApplication.shared.open(vURL)
        }
        
        if item == .share {
            guard let shareCell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            self.shareButtonClick(shareCell)
        }
        
        if item == .autofill {
            let autoVC = AutofillPassViewController()
            self.navigationController?.pushViewController(autoVC, animated: true)
        }
        
        if item == .guideVIP {
            KakaAppStoreManager.presentPurcharseVC(self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = dataArray[indexPath.section]
        let item = group.itemArray[indexPath.row]
        
        if item == .guideVIP || item == .userInfo {
            return UITableView.automaticDimension
        } else {
            return 55.ckValue()
        }
    }

    func shareButtonClick(_ shareCell: UITableViewCell) {
        guard let vUrl = URL(string: "https://apps.apple.com/app/id\(appstoreID)") else {
            return
        }
        
        if kaka_IsMacOS() {
            self.showOneAlert(title: "Tip".localStr(), message: vUrl.absoluteString, confirm: "Copy".localStr()) {
                UIPasteboard.general.string = vUrl.absoluteString
                self.view.makeToast("Copied Successful".localStr())
            }
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: [vUrl], applicationActivities: nil)
        if !kaka_IsiPhone() {
            shareVC.preferredContentSize = CGSize(width: 500.ckValue(), height: 450.ckValue())
            shareVC.modalPresentationStyle = .popover
            
            let popVC = shareVC.popoverPresentationController
            popVC?.delegate = self
            popVC?.backgroundColor = UIColor.clear
            popVC?.permittedArrowDirections = .down
            popVC?.sourceRect = CGRectMake(0, 0, kaka_screen_width(), kaka_screen_height())
            popVC?.sourceView = self.contentView
        }
        self.present(shareVC, animated: true, completion: nil)
    }
    
}
