//
//  ActiveSuccessExtensionView.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2023/12/3.
//

import KakaFoundation


class ActiveSuccessExtensionView: UIView {
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
        self.addSubview(emptyImgView)
        self.addSubview(tipsLabel)
        self.addSubview(messageLabel)
        self.addSubview(doneButton)
        self.addSubview(closeButton)
    }
    
    private func preSetupContains() {
        emptyImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(200.ckValue())
            make.top.equalTo(100.ckValue())
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImgView.snp.bottom).offset(30.ckValue())
            make.size.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipsLabel.snp.bottom).offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
            make.width.equalToSuperview().multipliedBy(0.78)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(closeButton.layer.cornerRadius * 2)
            make.bottom.equalToSuperview().inset(kaka_IsMacOS() ? 40.ckValue() : 130.ckValue())
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(closeButton)
            make.bottom.equalTo(closeButton.snp.top).offset(-20.ckValue())
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = UIColor.systemBackground
    }
    
    @objc func doneButtonClick() {
        self.onDoneCallBack?(self)
    }
    
    @objc func closeButtonClick() {
        self.onCancelCallBack?(self)
    }
    
    // MARK: 🌹 GET && SET 🌹
    var onDoneCallBack: ((ActiveSuccessExtensionView)->Void)?
    var onCancelCallBack: ((ActiveSuccessExtensionView)->Void)?
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var emptyImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "strong_pass_2"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 20.ckValue())
        view.textColor = UIColor.label
        view.textAlignment = .center
        view.text = "Activation Successful".localStr()
        view.numberOfLines = 0
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = UIColor.secondaryLabel
        view.textAlignment = .center
        view.text = "Next time, you can click the [Password] button at the top of the keyboard to turn on password autofill.".localStr()
        view.numberOfLines = 0
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = appMainColor
        view.setTitle("Experience it now".localStr(), for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.setTitleColor(UIColor.white, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 23
        view.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.clear
        view.setTitle("Back to Settings".localStr(), for: .normal)
        view.titleLabel?.font = doneButton.titleLabel?.font
        view.setTitleColor(appMainColor, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 23
        view.layer.borderWidth = 1.5
        view.layer.borderColor = appMainColor.cgColor
        view.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return view
    }()

}
