//
//  PasscodeVerifyViewController.swift
//  PhotoVault
//
//  Created by Melo on 2024/1/17.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import LocalAuthentication


let kScreenCodeMaxCount = 4

class PasscodeVerifyViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    init(_ isModify: Bool) {
        self.isModify = isModify
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
    
    private func preSetupSubViews() {
        
        self.view.backgroundColor = UIColor.clear
        
        self.modalPresentationStyle = .fullScreen
        
        self.view.addSubview(topSectionView)
        self.view.addSubview(bottomSectionView)
        self.view.addSubview(lineView)
        self.view.addSubview(appIconbackColorView)
        appIconbackColorView.addSubview(appIconImageView)
        
        bottomSectionView.addSubview(statusLabel)
        bottomSectionView.addSubview(resultView)
        bottomSectionView.addSubview(passcodeView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topSectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height * (isSmailDevice ? 0.17 : 0.24))
        bottomSectionView.frame = CGRectMake(0, CGRectGetMaxY(topSectionView.frame), topSectionView.width, self.view.height - topSectionView.top - topSectionView.height)
        passcodeView.size = CGSizeMake(self.view.width, 350.ckValue())
        
        lineView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(topSectionView.snp.bottom)
            make.height.equalTo(1.ckValue())
        }
        
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
            make.top.equalToSuperview().offset(appLogoSize / 2 + 30.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        resultView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(20.ckValue())
            make.size.equalTo(resultView.size)
        }
        
        passcodeView.snp.remakeConstraints { make in
            make.top.equalTo(resultView.snp.bottom).offset(25.ckValue())
            make.centerX.equalToSuperview()
            make.size.equalTo(passcodeView.size)
        }
        
    }
    
    private func preSetupHandleBuness() {
        
        ScreenLockManager.shared.isCheckSuccess = false
        self.handleBackgoundColor()
        
        #if MAIN_APP
        if #available (iOS 16.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.message.fill")?.flippedImage(), style: .done, target: self, action: #selector(helpButtonClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "message.fill")?.flippedImage(), style: .done, target: self, action: #selector(helpButtonClick))
        }
        if self.isModify {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelItemClick))
            self.navigationItem.leftBarButtonItem?.tintColor = appMainColor
            
        }else{
            let screenModel = ScreenLockManager.shared.getScreenPassCode()
            if screenModel.isFaceIdEnble && screenModel.fakePassword == nil {
                self.faceIDButtonClick()
            }
        }
        #else
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelItemClick))
        self.navigationItem.leftBarButtonItem?.tintColor = appMainColor
        
        let screenModel = ScreenLockManager.shared.getScreenPassCode()
        if screenModel.isFaceIdEnble && screenModel.fakePassword == nil {
            self.faceIDButtonClick()
        }
        
        #endif
                
        
       
    }
    
    @objc func cancelItemClick() {
        self.onCancelCallBack?()
        self.navigationController?.dismiss(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        topSectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height * (isSmailDevice ? 0.17 : 0.24))
        bottomSectionView.frame = CGRectMake(0, CGRectGetMaxY(topSectionView.frame), topSectionView.width, self.view.height - topSectionView.top - topSectionView.height)
        passcodeView.size = CGSizeMake(self.view.width, 350.ckValue())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        
        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground() // 底层透明，但内容穿透
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        
        self.startRotationAnimation()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        appIconbackColorView.layer.shadowColor = UIColor.label.withAlphaComponent(0.5).cgColor
        self.handleBackgoundColor()
    }
    
    // MARK:  GET && SET
    
    var isModify: Bool!
    
    var onRightCallBack: (()->Void)?
        
    var onCancelCallBack: (()->Void)?
    
    var isSmailDevice: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == .phone && self.view.window?.safeAreaInsets.bottom == 0
        }
    }
    
    var appLogoSize: CGFloat {
        get {
            return isSmailDevice ? 80.ckValue() : 100.ckValue()
        }
    }
        
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
        view.text = "Verify Screen Passcode".localStr()
        view.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        view.textAlignment = .center
        view.textColor = UIColor.secondaryLabel
        return view
    }()
    
    lazy var passcodeView: ScreenPassCodeView = {
        let view = ScreenPassCodeView(frame: CGRectMake(0, 0, self.view.width, 350.ckValue()))
        view.delegate = self
        view.faceidButton?.isHidden = false
        return view
    }()
    
    lazy var resultView: PasscodeResultView = {
        let view = PasscodeResultView(frame: CGRectMake(0, 0, 180.ckValue(), 40.ckValue()))
        return view
    }()
    
    @objc func faceIDButtonClick() {
        let screenModel = ScreenLockManager.shared.getScreenPassCode()
        
        if screenModel.fakePassword != nil {
            self.view.makeToast("Please Enter Passcode".localStr())
            return
        }
        
        if !screenModel.isFaceIdEnble {
            self.view.makeToast("You didn't enable biometrics, please enter passcode!".localStr())
            return
        }
        
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if context.biometryType == .none {
                self.handleNoneFaceTouchID(error)
                return
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "You can unlock this app using Face ID or Touch ID".localStr()) { [weak self] finish, error in
                DispatchQueue.main.async {
                    if finish {
                        self?.playSuccessAnimation()
                    }else{
                        self?.handleNoneFaceTouchID(error as NSError?)
                    }
                }
            }
        }else{
            self.handleNoneFaceTouchID(error)
        }
        
    }
    
    func handleNoneFaceTouchID(_ error: NSError?) {
        self.view.makeToast(error?.localizedDescription)
    }
    
    #if MAIN_APP
    @objc func helpButtonClick() {
        let helpVC = TransparencyViewController()
        helpVC.title = "Technical Support".localStr()
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
    #else
    @objc func helpButtonClick() {
        
    }
    #endif
    
}

extension PasscodeVerifyViewController: ScreenPassCodeViewDelegate {
    
    func screenPassCodeViewDidClick(codeView: ScreenPassCodeView, passCode: ScreenPassCode) {
        if passCode == .codeFace {
            self.faceIDButtonClick()
            return
        }
        
        if passCode == .codeDelete {
            self.resultView.deletePasscode()
        }else{
            let firstPasscode = self.resultView.addPasscode(passCode) ?? ""
            debugPrint("firstPasscode = \(firstPasscode)")
            let isFinished = firstPasscode.count >= 4
            if isFinished {
                self.verifyScreenPasscode()
            }
        }
        
    }
    
    @objc func verifyScreenPasscode() {
        
        let isRealCode = ScreenLockManager.shared.getScreenPassCode().password == self.resultView.passcodeStr
        
        if !isRealCode {
            statusLabel.text = "Incorrect Passcode".localStr()
            statusLabel.textColor = UIColor.red
            statusLabel.kaka_playShakeAnim()
            self.view.isUserInteractionEnabled = false
            self.perform(#selector(resetStatusLabel), afterDelay: 2)
            return
        }
        
        self.playSuccessAnimation()
    }
    
    @objc func resetStatusLabel() {
        self.view.isUserInteractionEnabled = true
        statusLabel.text = "Verify Screen Passcode".localStr()
        statusLabel.textColor = UIColor.secondaryLabel
        self.resultView.clearAllPasscode()
    }
    
    
    func playSuccessAnimation() {
        
        ScreenLockManager.shared.isCheckSuccess = true
                
        self.view.isUserInteractionEnabled = false
        
        ScreenLockManager.shared.removeBackgroundTime()
        
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
                wSelf.onRightCallBack?()
                wSelf.navigationController?.dismiss(animated: false)
            }
        }
        
    }
    
}


extension UIView {
    func rotateAndScaleAnimation(duration: TimeInterval) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2) // 360 degrees
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0
        scaleAnimation.duration = duration

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotationAnimation, scaleAnimation]
        animationGroup.duration = duration
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards

        layer.add(animationGroup, forKey: "rotateAndScaleAnimation")
    }
    
}
