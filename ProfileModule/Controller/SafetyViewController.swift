//
//  SafetyViewController.swift
//  PassLock
//
//  Created by Melo on 2024/3/16.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import LocalAuthentication

class SafetyViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = contentView.bounds
        headView.size = CGSizeMake(self.view.width, 150.ckValue())
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.title = UserCellItemType.autoLock.titleStr()
        self.refreshDataSource()
    }
    
    func refreshDataSource() {
        var tempArray = [SafetyGroupCellModel]()
        
        let model1 = SafetyGroupCellModel(group: .passwordGroup, headTitle: "", itemArray: [.passwordSwitch, .passwordModify], footTitle: "Passwords are for the current device only and will not be synchronized to any cloud, uninstalling the app will delete the passwords.".localStr())
        let model2 = SafetyGroupCellModel(group: .faceidGroup, headTitle: nil, itemArray: [.enableFaceID], footTitle: "Once enabled, this biometric unlocking will be used automatically".localStr())
        let model3 = SafetyGroupCellModel(group: .timeGroup, headTitle: "When entering the background".localStr(), itemArray: [.backgroundTime], footTitle: "When locked it will be unlocked using a password or biometrics".localStr())
        let model4 = SafetyGroupCellModel(group: .maskGroup, headTitle: nil, itemArray: [.backgroundMask], footTitle: "The app will display a blur mask when it enter background".localStr())
        
        tempArray.append(model1)
        tempArray.append(model2)
        tempArray.append(model3)
        tempArray.append(model4)
        
        dataArray = tempArray
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    // MARK: 🌹 GET && SET 🌹
    var dataArray: [SafetyGroupCellModel] = []
    
    var screenModel = ScreenLockManager.shared.getScreenPassCode()
    
    // MARK: 🌹 Lazy init 🌹
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 55.ckValue()
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(SafetyTableViewCell.self, forCellReuseIdentifier: "SafetyTableViewCell")
        return view
    }()
    
    lazy var headView: UIView = {
        let currentType = LAContext().biometryType
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 150.ckValue()))
        view.backgroundColor = .clear
        let faceImgView = UIImageView(image: currentType.supportIDImage())
        faceImgView.contentMode = .scaleAspectFit
        faceImgView.tintColor = appMainColor
        view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10.ckValue())
            make.size.equalTo(68.ckValue())
        }
        return view
    }()
    
}

extension SafetyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SafetyTableViewCell", for: indexPath) as! SafetyTableViewCell
        let item = dataArray[indexPath.section].itemArray[indexPath.row]
        cell.update(item: item, screenModel: self.screenModel)
        
        cell.onCallBack = { [weak self] (vModel, vItem) in
            self?.screenModel = vModel
            
            if item == .enableFaceID { return }
            if item == .backgroundMask { return }
            
            if item == .passwordSwitch {
                let modifyCellCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SafetyTableViewCell
                modifyCellCell?.update(item: .passwordModify, screenModel: vModel)
                
                let faceidCellCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SafetyTableViewCell
                faceidCellCell?.update(item: .enableFaceID, screenModel: vModel)
                
                let timeCellCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? SafetyTableViewCell
                timeCellCell?.update(item: .backgroundTime, screenModel: vModel)
                
                if vModel.isPasswordEnble {
                    self?.setPasscodeController(false)
                }
            }
            
            if item == .backgroundTime {
                let timeCellCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? SafetyTableViewCell
                timeCellCell?.update(item: .backgroundTime, screenModel: vModel)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataArray[indexPath.section].itemArray[indexPath.row]
        if item == .passwordModify && screenModel.isPasswordEnble {
            let verifyVC = PasscodeVerifyViewController(true)
            verifyVC.onRightCallBack = { [weak self] () in
                self?.perform(#selector(self?.setPasscodeController(_:)), afterDelay: 2)
            }
            let navVC = KakaNavigationController(rootViewController: verifyVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
    }
    
    @objc func setPasscodeController(_ isDidSelect: Bool = true) {
        let setVC = PasscodeSetViewController()
        if !isDidSelect {
            setVC.onCallBack = { [weak self] (success) in
                guard let wSelf = self else { return }
                if success {
                    wSelf.view.makeToast("Successful".localStr())
                }else{
                    wSelf.screenModel.isPasswordEnble = false
                    wSelf.screenModel.password = nil
                    ScreenLockManager.shared.saveScreenPassCode(wSelf.screenModel)
                    wSelf.tableView.reloadData()
                }
            }
        }
        let navVC = KakaNavigationController(rootViewController: setVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = dataArray[section]
        return group.headTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group = dataArray[section]
        return group.footTitle
    }
    
    
}
