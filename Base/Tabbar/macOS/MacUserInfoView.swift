//
//  MacUserInfoView.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import SDWebImage

class MacUserInfoView: UIView {
    
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
        self.addSubview(selectView)
        
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(arrowView)
    }
    
    private func preSetupContains() {
        
        selectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5.ckValue())
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.size)
        }
        
        avatarView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-30.ckValue())
            make.size.equalTo(avatarView.layer.cornerRadius * 2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(5.ckValue())
            make.centerY.equalTo(avatarView)
            make.trailing.equalTo(arrowView.snp.leading).offset(-5.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .clear
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(userInfoViewClick))
        self.addGestureRecognizer(clickTap)
        
        self.isSelect = true
        
        self.update()
    }
    
    @objc func userInfoViewClick() {
        self.isSelect = true
        self.onClickCallBack?()
    }
    
    // MARK:  GET && SET
    var isSelect: Bool = true {
        didSet {
            self.selectView.isHidden = !isSelect
        }
    }
    
    var onClickCallBack: (()->Void)?
    
    @objc func update() {
        
        self.avatarView.image = userModel.getAvatarImage()

        if let nickName = userModel.nickName, nickName.count > 0 {
            self.nameLabel.text = nickName
        }else{
            self.nameLabel.text = "None"
        }
                
    }
    
    // MARK:  Lazy Init
    
    lazy var selectView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.masksToBounds = true
        view.backgroundColor = kaka_IsMacOS() ? UIColor.systemFill : UIColor.placeholderText
        return view
    }()
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView(image: avatarImage)
        view.backgroundColor = UIColor.rgb(191, 211, 253)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 20.ckValue()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = UIFontLight(14.ckValue())
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.text = UIDevice.current.name
        view.textColor = UIColor.label
        return view
    }()
    
    lazy var arrowView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("chevron.right", color: UIColor.secondaryLabel).flippedImage())
        view.bounds = CGRectMake(0, 0, 15.ckValue(), 15.ckValue())
        view.contentMode = .scaleAspectFit
        return view
    }()
}


