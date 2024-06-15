//
//  CreatedPasswordView.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/26.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class CreatedPasswordView: UIView {
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
        self.addSubview(passBackView)
        self.addSubview(passLabel)
        
        self.addSubview(copyedView)
        self.addSubview(copyLabel)
    }
    
    private func preSetupContains() {
        
        copyedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(copyedView.size)
        }
        
        passLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35.ckValue())
            make.centerX.equalToSuperview()
            make.top.equalTo(copyedView.snp.bottom).offset(30.ckValue())
            make.height.greaterThanOrEqualTo(passLabel.font.lineHeight)
        }
        
        passBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20.ckValue())
            make.center.equalTo(passLabel)
            make.top.equalTo(passLabel.snp.top).offset(-16.ckValue())
            make.bottom.equalToSuperview()
        }
        
        copyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(copyedView)
            make.size.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        
       
    }
    
    // MARK: 🌹 GET && SET 🌹
    let copy1 = "Not copied".localStr()
    let copy2 = "Copied Successful".localStr()
    // MARK: 🌹 Lazy Init 🌹
    
    lazy var passBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.ckValue()
        return view
    }()
    
    lazy var copyedView: KakaAutoCornerView = {
        
        let longStr = copy1.count > copy2.count ? copy1 : copy2
        
        let width = longStr.width(copyLabel.font) + 30.ckValue()
        let height = copyLabel.font.lineHeight + 15.ckValue()
        let view = KakaAutoCornerView(frame: CGRectMake(0, 0, width, height))
        view.backgroundColor = UIColor.rgb(254, 203, 109)
        view.sksCornersInfo = ([PhoneSetManager.isArabicLanguage() ? UIRectCorner.bottomRight : UIRectCorner.bottomLeft], passBackView.layer.cornerRadius)
        return view
    }()
    
    lazy var copyLabel: UILabel = {
        let text = copy2
        let textFont = UIFontLight(12.ckValue())
        let textWidth = text.width(textFont) + 10.ckValue()
        
        let view = UILabel(frame: CGRectMake(0, 0, textWidth, textFont.lineHeight))
        view.text = copy1
        view.font = textFont
        view.textColor = UIColor.rgb(11, 33, 60)
        return view
    }()
    
    lazy var passLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = UIFontBold(18.ckValue())
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

}
