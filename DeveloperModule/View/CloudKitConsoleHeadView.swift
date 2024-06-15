//
//  CloudKitConsoleHeadView.swift
//  PassLock
//
//  Created by Melo on 2024/5/29.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class CloudKitConsoleHeadView: UIView {
    
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
        self.addSubview(openImgView)
        self.addSubview(blueView)
        self.addSubview(messageLabel)
    }
    
    private func preSetupContains() {
        openImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15.ckValue())
            make.width.equalToSuperview()
            make.height.equalTo(220.ckValue())
        }
        
        blueView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(openImgView.snp.bottom)
            make.height.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(blueView).offset(30.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = UIColor.rgb(110, 168, 175)
    }
    
    static func allheight(_ maxWidth: CGFloat) -> CGFloat {
        let avavtarHeight = 15.ckValue() + 220.ckValue()
        
        let messageHeight = Self.messageStr.ocString.height(for: Self.messageFont, width: maxWidth - 40.ckValue())
        
        return avavtarHeight + messageHeight + 60.ckValue() + 40.ckValue()
    }
    
    // MARK:  GET && SET
    static let messageStr = "As a password manager, it is very important for you to understand how your data is stored. Simply put, your data is stored only in your private iCloud database (the other is known as the public database) with strict AES256 encryption, which is inaccessible even to Apple and developers.".localStr()
    static let messageFont = UIFontLight(16.ckValue())
    
    // MARK:  Lazy Init
    lazy var openImgView: UIImageView = {
        let svgUrl = Reasource.svgFileUrl("opensource_1")
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.sd_setImage(with: URL(fileURLWithPath: svgUrl))
        return view
    }()
    
    // https://icloud.developer.apple.com/
    lazy var blueView: KakaAutoCornerView = {
        let view = KakaAutoCornerView(frame: CGRect(x: 0, y: 0, width: self.width, height: 30.ckValue()))
        view.sksCornersInfo = ([UIRectCorner.topLeft, UIRectCorner.topRight], 20.ckValue())
        view.backgroundColor = UIColor.systemBlue
        return view
    }()

    lazy var messageLabel: UILabel = {
        let view = UILabel()
        
        let attach1 = NSTextAttachment()
        attach1.image = Reasource.named("reply_char_start").withTintColor(UIColor.rgb(217, 245, 194)).flippedImage()
        attach1.bounds = CGRect(x: 0, y: -5, width: 30, height: 30)
        
        let attach2 = NSTextAttachment()
        attach2.image = Reasource.named("reply_char_end").withTintColor(UIColor.rgb(217, 245, 194)).flippedImage()
        attach2.bounds = CGRect(x: 0, y: -15, width: 30, height: 30)
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(attachment: attach1))
        attributedText.append(self.introduceAttbuteStr())
        attributedText.append(NSAttributedString(attachment: attach2))
        
        view.attributedText = attributedText
        view.numberOfLines = 0
        return view
    }()

    func introduceAttbuteStr() -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        paragraphStyle.lineSpacing = 5.ckValue()
        let attbutes: [NSAttributedString.Key: Any] = [.font: Self.messageFont, .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]
        
        let sumStr = Self.messageStr
        
        let attributedText = NSAttributedString(string: " " + sumStr + " ", attributes: attbutes)
        
        return attributedText
    }
    
}
