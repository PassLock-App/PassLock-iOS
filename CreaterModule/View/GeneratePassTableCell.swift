//
//  GeneratePassTableCell.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit


class GeneratePassTableCell: UITableViewCell {
    
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
        self.selectionStyle = .none
        
        contentView.addSubview(passwordView)
        contentView.addSubview(passTypeView)
        contentView.addSubview(retryButton)
        contentView.addSubview(copypassButton)
        contentView.addSubview(ruleView)
        
    }
    
    private func preSetupContains() {
        
        passwordView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
        
        passTypeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20.ckValue())
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordView.snp.bottom).offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        retryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passTypeView.snp.bottom).offset(10.ckValue())
            make.size.equalTo(40.ckValue())
        }
        
        copypassButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(passTypeView)
            make.height.equalTo(copypassButton.layer.cornerRadius * 2)
            make.top.equalTo(retryButton.snp.bottom).offset(10.ckValue())
        }
        
        ruleView.snp.makeConstraints { make in
            make.leading.equalTo(passTypeView)
            make.centerX.equalToSuperview()
            make.top.equalTo(copypassButton.snp.bottom).offset(40.ckValue())
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview().inset(30.ckValue())
        }
        
    }
    
    
    private func preSetupHandleBuness() {
        self.createPassword()
        NotificationCenter.default.addObserver(self, selector: #selector(appModeSwitchChanged), name: NSNotification.Name(kAppThemeColorChangedKey), object: nil)
        self.appModeSwitchChanged()
    }
        
    @objc func appModeSwitchChanged() {
        if !kaka_IsiPhone() {
            copypassButton.backgroundColor = appMainColor
        }
        
        var refreshImage: UIImage? = Reasource.named("refresh_password").withTintColor(UIColor.label)
        if kaka_IsiPad() {
            let value = refreshImage!.size.height / refreshImage!.size.width
            refreshImage = refreshImage?.byResize(to: CGSize(width: 30.ckValue(), height: 30.ckValue() * value))
        }
        retryButton.setImage(refreshImage, for: .normal)
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    let passNormalColor = UIColor.rgb(38, 38, 38)
    
    
    var passFormat: PasswordFormat = .randomPass
    
    
    // MARK: 🌹 Lazy Init 🌹
    
    lazy var passwordView: CreatedPasswordView = {
        let view = CreatedPasswordView()
        return view
    }()
    
    lazy var passTypeView: CreatePassTypeSelectView = {
        let view = CreatePassTypeSelectView()
        view.onCreateCallBack = { [weak self] (vPassFormat) in
            guard let wSelf = self else { return }
            if vPassFormat == wSelf.passFormat { return }
            wSelf.passFormat = vPassFormat
            if vPassFormat == .pinPassCode {
                wSelf.ruleView.defaultLong = 6
                wSelf.ruleView.isNumber = true
                wSelf.ruleView.isCharacter = false
                wSelf.ruleView.isUserInteractionEnabled = false
            }else{
                wSelf.ruleView.isUserInteractionEnabled = true
                wSelf.ruleView.defaultLong = 16
                wSelf.ruleView.isNumber = true
                wSelf.ruleView.isCharacter = true
            }
            wSelf.startCreatePassword()
        }
        return view
    }()
    
    lazy var retryButton: UIButton = {
        let view = UIButton(type: .custom)
        view.imageView?.contentMode = .scaleAspectFit
        view.addTarget(self, action: #selector(createPassword), for: .touchUpInside)
        return view
    }()
    
    lazy var copypassButton: UIButton = {
        
        let font = UIFontBold(16.ckValue())
        let text = "Copy security password".localStr()
        let colors = [UIColor.systemBlue.cgColor, UIColor.hexColor("#FF00FF").cgColor]
        
        let view = UIButton(frame: CGRectMake(0, 0, kaka_content_width() - 40.ckValue(), 44.ckValue()))
        if kaka_IsiPhone() {
            view.drawHorizontalGradientLayer(colors)
        }else{
            view.backgroundColor = appMainColor
        }
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.setTitleColor(UIColor.white, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 22.ckValue()
        view.addTarget(self, action: #selector(copypassButtonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var ruleView: PassCreateRuleView = {
        let view = PassCreateRuleView()
        view.defaultLong = 16
        view.isNumber = true
        view.isCharacter = true
        view.delegate = self
        return view
    }()
    
    lazy var passGenarator: StrongPasswordGenerator = {
        return StrongPasswordGenerator()
    }()

}

extension GeneratePassTableCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
