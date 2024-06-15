//
//  WelcomeCreatePassCell.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/21.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

class WelcomeCreatePassCell: UITableViewCell {
    
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(moreButton)
    }
    
    private func preSetupContains() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(10.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalTo(12.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(30.ckValue())
            make.size.equalTo(moreButton.size)
            make.bottom.equalToSuperview().inset(30.ckValue())
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        self.backgroundColor = appMainColor

        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let newColor = noti.object as? UIColor else { return }
        self.backgroundColor = newColor
        self.moreButton.setTitleColor(newColor, for: .normal)
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var titleLabel: UILabel = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3.ckValue()
        let attbutes: [NSAttributedString.Key: Any] = [.font: UIFontBold(20.ckValue()), .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "Strong Password Generator".localStr(), attributes: attbutes))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = attributedText
        view.textAlignment = .center
        return view
    }()
    
    lazy var descLabel: UILabel = {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3.ckValue()
        let attbutes: [NSAttributedString.Key: Any] = [.font: UIFontLight(14.ckValue()), .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]

        let message = "Setting a strong, unique password for each account regularly is the best way to defend against cyberattacks and Dark Web threats".localStr()
        let attributedText = NSAttributedString(string: message, attributes: attbutes)
        
        let view = UILabel()
        view.attributedText = attributedText
        view.numberOfLines = 0
        return view
    }()
    
    lazy var moreButton: UIButton = {
        let font = UIFontBold(15.ckValue())
        let width = text.width(font) + 40.ckValue()
        
        let view = UIButton(frame: CGRectMake(0, 0, width > 200.ckValue() ? width : 200.ckValue(), 44.ckValue()))
        view.isUserInteractionEnabled = false
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.backgroundColor = .white
        view.setTitleColor(appMainColor, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 22.ckValue()
        return view
    }()
    
}
