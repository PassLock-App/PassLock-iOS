//
//  PreferceViewController.swift
//  Kaka
//
//  Created by Kaka Inc.on 2022/7/30.
//

import KakaFoundation
import KakaUIKit
import KakaObjcKit
import MessageUI
import AppGroupKit
import SafariServices
import MBProgressHUD
import Toast_Swift
import LocalAuthentication
import StoreKit

class PreferceViewController: SuperViewController, UIPopoverPresentationControllerDelegate {
    
    public override func preSetupSubViews() {
        super.preSetupSubViews()
        self.title = UserCellItemType.aboutUS.titleStr()
        
        contentView.addSubview(tableView)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                        
        tableView.frame = contentView.bounds
        
    }
    
    public override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.perform(#selector(getCacheSize), afterDelay: 1.5)
    }
    
    @objc func getCacheSize() {
        DispatchQueue.global().sync {
            let cache = KakaCacheTools.getCacheSize()
            DispatchQueue.main.async {
                self.cacheSize = cache
                self.tableView.reloadData()
            }
        }
    }
    
    let dataArray = [["App"], ["Privacy Policy".localStr(), "Terms of Service".localStr()], ["Language".localStr(),"Clear cache".localStr(), "Rate us".localStr()], ["Delete Account".localStr()]]
    
    var cacheSize: String = ""
    
    // MARK: 🌹 Lazy init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: contentView.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = self.footView()
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(AboutAppTableCell.self, forCellReuseIdentifier: "AboutAppTableCell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
        return view
    }()
    
    func footView() -> UIView {
        let footView = UIView(frame: CGRectMake(0, 0, self.view.width, 40.ckValue()))
        let beianhaoLabel = UILabel()
        beianhaoLabel.isHidden = !PhoneSetManager.isChineseMainLand()
        beianhaoLabel.text = "粤ICP备2023115933号-1A"
        beianhaoLabel.isUserInteractionEnabled = true
        beianhaoLabel.font = UIFontLight(10.ckValue())
        beianhaoLabel.textColor = UIColor.secondaryLabel
        beianhaoLabel.textAlignment = .center
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(beianhaoClick(_:)))
        beianhaoLabel.addGestureRecognizer(clickTap)
        footView.addSubview(beianhaoLabel)
        beianhaoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.greaterThanOrEqualTo(0)
        }
        return footView
    }
    
    @objc func beianhaoClick(_ sender: UITapGestureRecognizer) {
        guard let vUrl = URL(string: "https://beian.miit.gov.cn/#/Integrated/index") else { return }
        
        UIApplication.shared.open(vUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
}

extension PreferceViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutAppTableCell", for: indexPath) as! AboutAppTableCell
            cell.backgroundColor = UIColor.clear
            return cell
        }else{
            let sectionArray = dataArray[indexPath.section]
            let title = sectionArray[indexPath.row]
            let isCancelCell = title == "Delete Account".localStr()

            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCell", for: indexPath)
            var cellConfig = UIListContentConfiguration.sidebarCell()
            cellConfig.text = title
            cellConfig.textProperties.color = UIColor.label
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            if title == "Clear cache".localStr() {
                cellConfig.secondaryText = self.cacheSize
                cellConfig.prefersSideBySideTextAndSecondaryText = true
            }
            
            if isCancelCell {
                cellConfig.attributedText = self.cancelAttbuteStr()
                cellConfig.textProperties.alignment = .center
            }
            
            cell.contentConfiguration = cellConfig
            cell.accessoryType = isCancelCell ? .none : .disclosureIndicator
            return cell
        }
        
    }
    
    func cancelAttbuteStr() -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center
        paraStyle.lineSpacing = 3.ckValue()
        
        let redColor = UIColor.rgb(252, 33, 38)
        
        let attbuteStr = NSMutableAttributedString()
        attbuteStr.append(NSAttributedString(string: "Delete Account".localStr(), attributes: [NSAttributedString.Key.font: UIFontBold(15.ckValue()), NSAttributedString.Key.foregroundColor: redColor, NSAttributedString.Key.paragraphStyle: paraStyle]))
        return attbuteStr
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = dataArray[indexPath.section][indexPath.row]
        
        if title == "Language".localStr() {
            guard let vUrl = URL(string: SystemSettingPath.settings.settingPathStr()) else { return }
            UIApplication.shared.open(vUrl)
        }
        
        if title == "Privacy Policy".localStr() {
            guard let vUrl = URL(string: kPrivacyUrl) else { return }
            
            if kaka_IsMacOS() {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let safariVC = SFSafariViewController(url: vUrl, configuration: config)
                safariVC.preferredControlTintColor = appMainColor
                self.navigationController?.present(safariVC, animated: true)
            } else {
                let webVC = WKWebViewController(urlStr: vUrl.absoluteString)
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        
        if title == "Terms of Service".localStr() {
            guard let vUrl = URL(string: kUseItemUrl) else { return }
            
            if kaka_IsMacOS() {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let safariVC = SFSafariViewController(url: vUrl, configuration: config)
                safariVC.preferredControlTintColor = appMainColor
                self.navigationController?.present(safariVC, animated: true)
            } else {
                let webVC = WKWebViewController(urlStr: vUrl.absoluteString)
                self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        
        if title == "Clear cache".localStr() {
            KakaCacheTools.finishCacheCompletion { [weak self] () in
                self?.cacheSize = "0kb"
                self?.tableView.reloadData()
            }
        }
        
        if title == "Rate us".localStr() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
        
        if title == "Delete Account".localStr() {
            let alertController: UIAlertController = UIAlertController(title: "❗️Dangerous operation❗️".localStr(), message: "This operation will delete all your data permanently and can't be recovered. Are you sure?".localStr(), preferredStyle: kaka_IsiPhone() ? .actionSheet : .alert)
            let action: UIAlertAction = UIAlertAction(title: "Delete".localStr(), style: .destructive) { [weak self] (sender) in
                self?.verifyOwerByFaceID()
            }
            let action2 : UIAlertAction = UIAlertAction(title: "Cancel".localStr(), style: .cancel)
            
            alertController.addAction(action)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else{
            return 50.ckValue()
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension PreferceViewController {
    
    func verifyOwerByFaceID() {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if context.biometryType == .none {
                self.view.makeToast(error?.localizedDescription)
                return
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "You can unlock this app using Face ID or Touch ID".localStr()) { [weak self] finish, error in
                DispatchQueue.main.async {
                    if finish {
                        self?.hanleCancelOperation()
                    }else{
                        self?.view.makeToast((error as NSError?)?.localizedDescription)
                    }
                }
            }
        }else{
            self.hanleCancelOperation()
        }
    }
    
    func hanleCancelOperation() {
        MBProgressHUD.showLoading("Please wait".localStr(), inView: self.view)
        AppICloudManager.shared.cancelAccountDeleteData { [weak self] () in
            guard let wSelf = self else { return }
            MBProgressHUD.hideLoading(wSelf.view)
            LocalNotificationManager.shared.deleteAllLocalNoti()
            wSelf.deleteSuccess()
        }
    }
    
    func deleteSuccess() {
        self.showOneAlert(title: "Account cancellation successful".localStr(), message: "All your data has been deleted. Welcome back again!".localStr(), confirm: "OK".localStr()) {
            self.switchAppKeyWindow()
        }
    }
    
    func switchAppKeyWindow() {
        let tabbarVC = WelcomeFirsterViewController()
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = tabbarVC
        scene?.window?.makeKeyAndVisible()
    }
}
