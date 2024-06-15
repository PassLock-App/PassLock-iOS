//
//  StrongPasswordViewCell.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/26.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation

class StrongPasswordViewCell: UITableViewCell {
    
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
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
    }
    
    private func preSetupContains() {
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20.ckValue())
            make.width.equalToSuperview().multipliedBy(0.618)
            make.height.equalTo(iconView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15.ckValue())
            make.top.equalTo(iconView.snp.bottom).offset(30.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(25.ckValue())
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview().inset(20.ckValue())
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: StrongPassword? {
        didSet {
            iconView.image = Reasource.named(model?.iconName ?? "")
            titleLabel.attributedText = model?.title
            messageLabel.attributedText = model?.message
        }
    }
    
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

}
