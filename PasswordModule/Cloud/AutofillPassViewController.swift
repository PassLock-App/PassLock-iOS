//
//  AutofillPassViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import KakaPhotoBrowser
import AuthenticationServices
import StoreKit

class AutofillPassViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        contentView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = contentView.bounds
        headView.size = CGSizeMake(self.view.width, (108 + 15 + 48 + 60).ckValue())
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.title = UserCellItemType.autofill.titleStr()
        self.update()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNoti), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func didBecomeActiveNoti() {
        self.tableView.reloadData()
        self.update()
        
        ASCredentialIdentityStore.shared.getState { storeStatus in
            DispatchQueue.main.async {
                if storeStatus.isEnabled {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
            }
        }
        
    }
    
    // MARK:  GET && SET
    func update() {
        ASCredentialIdentityStore.shared.getState { storeStatus in
            DispatchQueue.main.async {
                self.headView.isAutofill = storeStatus.isEnabled
            }
        }
    }
    
    lazy var dataArray: [AutoFillPasswordStep] = {
        return [.guideStep1, .guideStep2, .guideStep3]
    }()
    
    // MARK:  Lazy Init
    lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.bounds, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 55.ckValue()
        view.rowHeight = UITableView.automaticDimension
        view.contentInsetAdjustmentBehavior = .automatic
        view.tableHeaderView = self.headView
        view.register(AutofillPassViewCell.self, forCellReuseIdentifier: "AutofillPassViewCell")
        return view
    }()
    
    lazy var headView: AutofillPassHeadView = {
        let view = AutofillPassHeadView(frame: CGRectMake(0, 0, self.view.width, (108 + 15 + 48 + 60).ckValue()))
        view.backgroundColor = .clear
        return view
    }()
    
}

extension AutofillPassViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = dataArray[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutofillPassViewCell", for: indexPath) as! AutofillPassViewCell
        cell.itemType = itemType
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        var tempArray = [KakaPhotoItem]()
        for index in 0..<dataArray.count {
            let subItem = dataArray[index]
            let sourceView = UIImageView(frame: CGRectMake(0, 0, 1, 1))
            sourceView.center = self.view.center
            sourceView.isHidden = true
            self.view.addSubview(sourceView)
            let item = KakaPhotoItem(sourceView: sourceView, image: subItem.cellImage())
            tempArray.append(item)
        }
                                
        let browser = KakaPhotoBrowser(photoItems: tempArray, selectedIndex: UInt(indexPath.section))
        browser.backgroundStyle = .blurPhoto
        browser.show(from: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].headStr()
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataArray[section].footStr()
    }
}


class AutofillPassViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        contentView.addSubview(openImgView)
    }
    
    private func preSetupContains() {
        let cellImage = CloudKitConsoleItemType.console1.cellImage()
        let imgVaule = cellImage.size.height / cellImage.size.width
        
        openImgView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(openImgView.snp.width).multipliedBy(imgVaule)
            make.bottom.equalToSuperview()
        }
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
    }
    
    // MARK:  GET && SET
    var itemType: AutoFillPasswordStep? {
        didSet {
            openImgView.image = itemType?.cellImage()
        }
    }
    
    
    // MARK:  Lazy Init
    lazy var openImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
}

class AutofillPassHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(faceImgView)
        self.addSubview(statusLabel)
        self.addSubview(settingButton)
    }
    
    private func preSetupContains() {
        faceImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(30.ckValue())
            make.size.equalTo(88.ckValue())
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(faceImgView.snp.bottom).offset(10.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(kaka_IsMacOS() ? -10 : 0)
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.equalTo(44.ckValue())
        }
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .clear
    }
    
    // MARK:  GET && SET
    var isAutofill: Bool = false {
        didSet {
            let image = isAutofill ? Reasource.systemNamed("checkmark.seal.fill", color: appMainColor) : Reasource.systemNamed("exclamationmark.triangle.fill", color: UIColor.red)
            faceImgView.image = image
            statusLabel.text = isAutofill ? "Activation Success".localStr() : "Autofill not activated".localStr()
        }
    }
    
    @objc func settingButtonClick() {
        if isAutofill {
            self.faceImgView.kaka_playShakeAnim()
            self.statusLabel.kaka_playShakeAnim()
            return
        }
        
        guard let settingURL = URL(string: SystemSettingPath.passwords.settingPathStr()) else { return }
        UIApplication.shared.open(settingURL)
    }
    
    // MARK:  Lazy Init
    lazy var faceImgView: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.tintColor = appMainColor
        return view
    }()
    
    lazy var settingButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = appMainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.ckValue()
        view.titleLabel?.font = UIFontLight(16.ckValue())
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(settingButtonClick), for: .touchUpInside)
        view.setTitle("Go to Autofill Settings".localStr(), for: .normal)
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.textAlignment = .center
        view.font = UIFontBold(16.ckValue())
        return view
    }()
    
}
