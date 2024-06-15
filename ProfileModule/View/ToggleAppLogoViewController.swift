//
//  ToggleAppLogoViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/6.
//


import KakaFoundation
import KakaUIKit
import MBProgressHUD
import AppGroupKit
import Toast_Swift

class ToggleAppLogoViewController: SuperViewController {
    
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
        self.title = UserCellItemType.toggleIcon.titleStr()
        self.refreshDataAction()
    }
    
    func refreshDataAction() {
        for index in 0..<11 {
            dataArray.append("logo\(index)")
        }
    
        if kaka_IsMacOS() {
            dataArray[0] = "mac_logo"
            dataArray.remove(at: 1)
        }
    
        self.tableView.reloadData()
    }

    
    // MARK:  GET && SET
    lazy var dataArray: [String] = {
        return [String]()
    }()
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 150.ckValue()
        view.tableHeaderView = self.headView
        view.contentInsetAdjustmentBehavior = .automatic
        view.register(UITableViewCell.self, forCellReuseIdentifier: "AppLogoTableCell")
        return view
    }()
    
    lazy var headView: UIView = {
        let iconImage = UIImage(systemName: "suit.spade.fill")
        
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, 130.ckValue()))
        let faceImgView = UIImageView(image: iconImage)
        faceImgView.contentMode = .scaleAspectFit
        view.addSubview(faceImgView)
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10.ckValue())
            make.size.equalTo(75.ckValue())
        }
        return view
    }()
    
}

extension ToggleAppLogoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppLogoTableCell", for: indexPath)
        let iconName = dataArray[indexPath.row]
        let isSelect = iconName == (UIApplication.shared.alternateIconName ?? "logo0")

        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.image = UIImage(named: iconName)
        cellConfig.imageProperties.maximumSize = CGSizeMake(100.ckValue(), 100.ckValue())
        cellConfig.imageProperties.cornerRadius = 20.ckValue()
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        if kaka_IsMacOS() {
            cellConfig.textProperties.font = UIFontLight(15.ckValue())
        }
        cell.contentConfiguration = cellConfig
        return cell
    }
    
    func proImgView() -> UIImageView {
        let view = UIImageView(image: Reasource.systemNamed("crown.fill"))
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }
    
    func selectImgView() -> UIImageView {
        let selectImage = Reasource.systemNamed("checkmark.circle.fill", color: appMainColor)
        let view = UIImageView(image: selectImage)
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }
    
    func unselectImgView() -> UIImageView {
        let normalImage = Reasource.systemNamed("circle", color: UIColor.label)
        let view = UIImageView(image: normalImage)
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 25.ckValue(), height: 25.ckValue())
        return view
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if kaka_IsMacOS() {
            self.showOneAlert(title: "Tip".localStr(), message: "Due to system restrictions, this is only supported by iPhone or iPad.".localStr(), confirm: "OK".localStr())
            return
        }
        
        self.toggleAppLogoAction(iconName)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Toggle desktop icons to better protect your privacy".localStr()
    }
    
    func toggleAppLogoAction(_ iconName: String?) {
        if !UIApplication.shared.supportsAlternateIcons {
            self.view.makeToast("This device doesn't support toggle the desktop icon".localStr())
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName) { [weak self] error in
            if (error == nil) {
                self?.tableView.reloadData()
            }else{
                self?.view.makeToast(error?.localizedDescription)
            }
        }
    }
    
}
