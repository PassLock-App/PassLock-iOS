//
//  PasscodeSetViewController.swift
//  PhotoVault
//
//  Created by Melo on 2024/1/17.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit


class PasscodeSetViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        self.view.backgroundColor = UIColor.clear
        
        self.modalPresentationStyle = .fullScreen
        contentView.addSubview(topSectionView)
        contentView.addSubview(bottomSectionView)
        contentView.addSubview(lineView)
        contentView.addSubview(appIconbackColorView)
        appIconbackColorView.addSubview(appIconImageView)
        
        bottomSectionView.addSubview(statusLabel)
        bottomSectionView.addSubview(resultView1)
        bottomSectionView.addSubview(resultView2)
        bottomSectionView.addSubview(passcodeView)
        bottomSectionView.addSubview(timeSpaceLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(topSectionView.snp.bottom)
            make.height.equalTo(1.ckValue())
        }
        
        topSectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height * (isSmailDevice ? 0.17 : 0.24))
        bottomSectionView.frame = CGRectMake(0, CGRectGetMaxY(topSectionView.frame), topSectionView.width, self.view.height - topSectionView.top - topSectionView.height)
        passcodeView.size = CGSizeMake(self.view.width, 350.ckValue())
        
        appIconbackColorView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(lineView)
            make.centerX.equalToSuperview()
            make.size.equalTo(appLogoSize)
        }
        
        appIconImageView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        statusLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLogoSize / 2 + 20.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        resultView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(20.ckValue())
            make.size.equalTo(resultView1.size)
        }
        
        resultView2.snp.makeConstraints { make in
            make.edges.equalTo(resultView1)
        }
        
        passcodeView.snp.remakeConstraints { make in
            make.top.equalTo(resultView1.snp.bottom).offset(25.ckValue())
            make.centerX.equalToSuperview()
            make.size.equalTo(passcodeView.size)
        }
        
        timeSpaceLabel.snp.makeConstraints { make in
            make.leading.equalTo(passcodeView).offset(12.ckValue())
            make.height.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom / 2 + 25.ckValue())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startRotationAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        
        self.handleBackgoundColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancleButtonClick))
        self.navigationItem.leftBarButtonItem?.tintColor = .label
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        topSectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height * (isSmailDevice ? 0.17 : 0.24))
        bottomSectionView.frame = CGRectMake(0, CGRectGetMaxY(topSectionView.frame), topSectionView.width, self.view.height - topSectionView.top - topSectionView.height)
        passcodeView.size = CGSizeMake(self.view.width, 350.ckValue())
    }
    
    private func startRotationAnimation() {
//        let animation1 = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation1.fromValue = 0
//        animation1.toValue = Double.pi * 2
//        animation1.duration = 4
//        animation1.repeatCount = .infinity
//        animation1.fillMode = .forwards
//        animation1.isRemovedOnCompletion = true
//        vaultIconView.layer.add(animation1, forKey: nil)
//        
//        
//        let animation2 = CABasicAnimation(keyPath: "transform.rotation.z")
//        animation2.fromValue = 0
//        animation2.toValue = -Double.pi * 2
//        animation2.duration = 8
//        animation2.repeatCount = .infinity
//        animation2.fillMode = .forwards
//        animation2.isRemovedOnCompletion = true
//        appIconImageView.layer.add(animation2, forKey: nil)
    }
    
    @objc func cancleButtonClick() {
        self.view.endEditing(true)
        self.onCallBack?(false)
        self.navigationController?.dismiss(animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        appIconbackColorView.layer.shadowColor = UIColor.label.withAlphaComponent(0.5).cgColor
        self.handleBackgoundColor()
    }
    
    // MARK:  GET && SET
    
    var isSmailDevice: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == .phone && kaka_safeAreaInsets().bottom == 0
        }
    }
    
    var appLogoSize: CGFloat {
        get {
            return isSmailDevice ? 80.ckValue() : 100.ckValue()
        }
    }
    
    var onCallBack: ((Bool)->Void)?
    
    func handleBackgoundColor() {
        
        let isDark = self.view.overrideUserInterfaceStyle == .dark
        var topBackgroundColor: UIColor!
        if isDark {
            self.view.backgroundColor = UIColor.secondarySystemBackground
            topBackgroundColor = UIColor.tertiarySystemBackground
        }else{
            self.view.backgroundColor = UIColor.systemBackground
            topBackgroundColor = UIColor.secondarySystemBackground
        }
        
        self.topSectionView.backgroundColor = topBackgroundColor
        self.passcodeView.buttonBackColor = topBackgroundColor
        self.passcodeView.backgroundColor = self.view.backgroundColor
    }
    
    // MARK:  Lazy init
    
    lazy var topSectionView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, self.view.width, self.view.height * (isSmailDevice ? 0.17 : 0.24)))
        return view
    }()
    
    lazy var bottomSectionView: UIView = {
        let view = UIView(frame: CGRectMake(0, CGRectGetMaxY(topSectionView.frame), topSectionView.width, self.view.height - topSectionView.top - topSectionView.height))
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    lazy var appIconbackColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 20.ckValue()
        view.layer.shadowColor = UIColor.label.withAlphaComponent(0.5).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
  
    lazy var appIconImageView: UIImageView = {
        let image = UIImage(named: kaka_IsMacOS() ? "mac_logo" : "app_logo")
        let view = UIImageView(image: image)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = appIconbackColorView.layer.cornerRadius
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.text = "Please set a passcode".localStr()
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.textAlignment = .center
        view.textColor = UIColor.secondaryLabel
        return view
    }()
    
    lazy var passcodeView: ScreenPassCodeView = {
        let view = ScreenPassCodeView(frame: CGRectMake(0, 0, self.view.width, 350.ckValue()))
        view.delegate = self
        view.faceidButton?.isHidden = true
        return view
    }()
    
    lazy var resultView1: PasscodeResultView = {
        let view = PasscodeResultView(frame: CGRectMake(0, 0, 180.ckValue(), 40.ckValue()))
        return view
    }()
    
    lazy var resultView2: PasscodeResultView = {
        let view = PasscodeResultView(frame: resultView1.bounds)
        view.isHidden = true
        return view
    }()
    
    lazy var timeSpaceLabel: UILabel = {
        let view = UILabel()
        view.text = "Default: App will lock after 5 mins in the background".localStr()
        view.font = UIFontLight(12.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.secondaryLabel
        view.numberOfLines = 0
        return view
    }()
    
}

extension PasscodeSetViewController: ScreenPassCodeViewDelegate {
    
    func screenPassCodeViewDidClick(codeView: ScreenPassCodeView, passCode: ScreenPassCode) {
        
        if !self.resultView1.isHidden {
            // 设置密码
            if passCode == .codeDelete {
                self.resultView1.deletePasscode()
            }else{
                let firstPasscode = self.resultView1.addPasscode(passCode) ?? ""
                debugPrint("firstPasscode = \(firstPasscode)")
                let isFinished = firstPasscode.count >= 4
                if isFinished {
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                        self.view.isUserInteractionEnabled = true
                        self.statusLabel.text = "Please Enter Passcode Again".localStr()
                        self.statusLabel.textColor = UIColor.secondaryLabel
                        self.resultView1.isHidden = isFinished
                        self.resultView2.isHidden = !isFinished
                        
                        self.statusLabel.kaka_playShakeAnim()
                    }
                }
            }
        }
        
        if !self.resultView2.isHidden {
            if passCode == .codeDelete {
                self.resultView2.deletePasscode()
            }else{
                let secondPasscode = self.resultView2.addPasscode(passCode) ?? ""
                debugPrint("secondPasscode = \(secondPasscode)")
                let isFinished = secondPasscode.count >= 4
                if isFinished {
                    self.finishPasscode()
                }
            }
        }
    }
    
    @objc func resetStatusLabel() {
        self.view.isUserInteractionEnabled = true
        statusLabel.text = "Please reset passcode".localStr()
        statusLabel.textColor = UIColor.secondaryLabel
        self.resultView1.isHidden = false
        self.resultView2.isHidden = true
        self.resultView1.clearAllPasscode()
        self.resultView2.clearAllPasscode()
    }
    
    @objc func finishPasscode() {
        if self.resultView1.passcodeStr != self.resultView2.passcodeStr {
            statusLabel.text = "Two passcodes don't match".localStr()
            statusLabel.textColor = UIColor.red
            statusLabel.kaka_playShakeAnim()
            self.view.isUserInteractionEnabled = false
            self.perform(#selector(resetStatusLabel), afterDelay: 2)
            return
        }
        
        var vModel = ScreenLockManager.shared.getScreenPassCode()
        vModel.password = self.resultView2.passcodeStr
        vModel.isPasswordEnble = true
        ScreenLockManager.shared.saveScreenPassCode(vModel)
        
        self.playSuccessAnimation()
    }
    
    func playSuccessAnimation() {
                
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        
        lineView.isHidden = true
        appIconImageView.layer.cornerRadius = appLogoSize / 2
        appIconImageView.rotateAndScaleAnimation(duration: 0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.35) { [weak self] () in
                guard let wSelf = self else { return }
                wSelf.topSectionView.top = -wSelf.topSectionView.height
                wSelf.bottomSectionView.top = wSelf.view.height
                wSelf.view.layoutIfNeeded()
            } completion: { [weak self] finish in
                guard let wSelf = self else { return }
                wSelf.onCallBack?(true)
                wSelf.navigationController?.dismiss(animated: false)
            }
        }
        
    }
    
}
