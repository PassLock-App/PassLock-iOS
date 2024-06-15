//
//  UserBasicViewCell.swift
//  Kaka
//
//  Created by Kaka Inc.on 2022/7/26.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class UserBasicViewCell: UITableViewCell {
    
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
        self.accessoryType = .none
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(avatarView)
        contentView.addSubview(uploadImgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(editIconView)
        contentView.addSubview(descdescLabel)
        contentView.addSubview(editNameControl)
    }
    
    private func preSetupContains() {
        
        avatarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.ckValue())
            make.centerX.equalTo(self)
            make.size.equalTo(avatarView.layer.cornerRadius * 2)
        }
        
        uploadImgView.snp.makeConstraints { make in
            make.trailing.equalTo(avatarView.snp.trailing).offset(5.ckValue())
            make.bottom.equalTo(avatarView.snp.bottom).offset(-5.ckValue())
            make.size.equalTo(uploadImgView.layer.cornerRadius * 2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(avatarView)
            make.top.equalTo(avatarView.snp.bottom).offset(6.ckValue())
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(nameLabel.font.lineHeight)
        }
        
        editIconView.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel.snp.bottom).offset(-3.ckValue())
            make.size.equalTo(15.ckValue())
            make.leading.equalTo(nameLabel.snp.trailing).offset(6.ckValue())
        }
        
        editNameControl.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.bottom.equalTo(nameLabel)
            make.trailing.equalTo(editIconView.snp.trailing)
        }
        
        descdescLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(3.ckValue())
            make.height.greaterThanOrEqualTo(descdescLabel.font.lineHeight)
            make.bottom.equalToSuperview().inset(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    //MARK: - 🌹 GET && SET 🌹
    
    var onClickAvatarCallBack: ((UserBasicViewCell)->Void)?
    
    var onClickNameCallBack: (()->Void)?
    
    @objc func update() {
        
    }
    
    //MARK: - 🌹 Lazy Init 🌹
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView(image: avatarImage)
        view.backgroundColor = UIColor.rgb(191, 211, 253)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 40.ckValue()
        view.isUserInteractionEnabled = true
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(clickAvatarTap))
        view.addGestureRecognizer(clickTap)
        return view
    }()
    
    lazy var uploadImgView: UIImageView = {
        let view = UIImageView(image: Reasource.named("camera_upload"))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 14.ckValue()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.ckValue()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontBold(18.ckValue())
        view.textAlignment = .center
        view.text = UIDevice.current.name
        view.textColor = UIColor.label
        return view
    }()
    
    lazy var descdescLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFontLight(14.ckValue())
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        return view
    }()
    
    lazy var editIconView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("highlighter", color: .label))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var editNameControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(nameCntrolTap), for: .touchUpInside)
        return control
    }()
    
    @objc func nameCntrolTap() {
        self.onClickNameCallBack?()
    }
    
    @objc func clickAvatarTap() {
        self.onClickAvatarCallBack?(self)
    }
    
    func playSharkAnimation() {
        self.nameLabel.kaka_playShakeAnim()
        self.editIconView.kaka_playShakeAnim()
        self.descdescLabel.kaka_playShakeAnim()
    }
}
