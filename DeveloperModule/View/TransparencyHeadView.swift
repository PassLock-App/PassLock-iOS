//
//  TransparencyHeadView.swift
//  PassLock
//
//  Created by Melo on 2024/5/29.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class TransparencyHeadView: UIView {
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
        self.backgroundColor = UIColor.rgb(110, 168, 175)
        
        self.addSubview(avatarView)
        self.addSubview(popView)
        self.addSubview(blueView)
        self.addSubview(messageLabel)
    }
    
    private func preSetupContains() {
        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.ckValue())
            make.width.equalTo(300.ckValue())
            make.height.equalTo(240.ckValue())
        }
        
        popView.snp.makeConstraints { make in
            make.centerX.equalTo(avatarView.snp.trailing)
            make.size.equalTo(50.ckValue())
            make.top.equalTo(avatarView).offset(10.ckValue())
        }
        
        blueView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom)
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
        
    }
    
    static func allheight(_ maxWidth: CGFloat) -> CGFloat {
        let avavtarHeight = 5.ckValue() + 240.ckValue()
        
        let messageHeight = Self.messageStr.ocString.height(for: Self.messageFont, width: maxWidth - 40.ckValue())
        
        return avavtarHeight + messageHeight + 60.ckValue() + 40.ckValue()
    }
    
    // MARK:  GET && SET
    static let messageStr = "Hi, This is Melo, the technical support for PassLock. We adhere to the values of openness and transparency and welcome scrutiny from everyone around the world. PassLock's code is now open source. If you encounter any issues, you can contact me via email.".localStr()
    static let messageFont = UIFontLight(16.ckValue())
    
    // MARK:  Lazy Init
    lazy var avatarView: UIImageView = {
        let view = UIImageView(image: Reasource.named(PhoneSetManager.isArabicLanguage() ? "avatar_6" : "avatar_1"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var popView: UIImageView = {
        let view = UIImageView(image: Reasource.named("pop_chat"))
        return view
    }()
    
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
