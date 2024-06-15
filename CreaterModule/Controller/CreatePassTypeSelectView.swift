//
//  CreatePassTypeSelectView.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/22.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

enum PasswordFormat: Int {
    case randomPass = 0
    case easyRemember = 1
    case pinPassCode = 2
    
}

class CreatePassTypeSelectView: UIView {
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
        addSubview(selectControl)
        addSubview(formatLabel)
        addSubview(arrowView)
    }
    
    private func preSetupContains() {
        
        selectControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(selectControl.layer.cornerRadius * 2)
            make.bottom.equalToSuperview()
        }
        
        formatLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25.ckValue())
            make.centerY.equalTo(selectControl)
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(formatLabel.font.lineHeight)
        }
        
        arrowView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20.ckValue())
            make.size.equalTo(arrowView.size)
            make.centerY.equalTo(selectControl)
        }
    }
    
    private func preSetupHandleBuness() {
        self.format = .randomPass
        self.backgroundColor = .clear
    }
    
    // MARK: 🌹 GET && SET 🌹
    public var format: PasswordFormat = .randomPass {
        didSet {
            formatLabel.text = format.formatStr()
            self.onCreateCallBack?(self.format)
        }
    }
    
    var onCreateCallBack: ((PasswordFormat)->Void)?
            
        
    // MARK: 🌹 Lazy Init 🌹
    lazy var arrowView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("chevron.right", color: UIColor.label).flippedImage())
        view.bounds = CGRectMake(0, 0, 20.ckValue(), 20.ckValue())
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var formatLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontLight(17.ckValue())
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.textColor = .label
        return view
    }()
    
    // 141,142,164
    lazy var selectControl: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 23.ckValue()
        view.layer.borderColor = UIColor.systemFill.cgColor
        view.layer.borderWidth = 1.ckValue()
        view.showsMenuAsPrimaryAction = true
        view.menu = self.menu
        return view
    }()

    lazy var menu: UIMenu = {
        let menu = UIMenu(title: "Password type".localStr(), children: [
            UIAction(title: PasswordFormat.randomPass.formatStr(), handler: { [weak self] _ in
                self?.format = .randomPass
                self?.formatLabel.text = PasswordFormat.randomPass.formatStr()
            }),
            UIAction(title: PasswordFormat.easyRemember.formatStr(), handler: { [weak self] _ in
                self?.format = .easyRemember
                self?.formatLabel.text = PasswordFormat.easyRemember.formatStr()
            }),
            UIAction(title: PasswordFormat.pinPassCode.formatStr(), handler: { [weak self] _ in
                self?.format = .pinPassCode
                self?.formatLabel.text = PasswordFormat.pinPassCode.formatStr()
            })
        ])
        return menu
    }()
}
