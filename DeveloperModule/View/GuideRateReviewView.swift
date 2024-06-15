//
//  GuideRateReviewView.swift
//  PassLock
//
//  Created by Melo on 2024/5/29.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

protocol GuideRateReviewViewDelegate: AnyObject {
    func guideCommentDidScore(cell: GuideRateReviewView)
    
    func guideCommentDidShare(cell: GuideRateReviewView)
}

class GuideRateReviewView: UIView {
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
        self.backgroundColor = UIColor.systemBlue
        
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        self.addSubview(appstoreButton)
        self.addSubview(shareButton)
    }
    
    private func preSetupContains() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20.ckValue())
            make.leading.equalTo(titleLabel)
            make.height.greaterThanOrEqualTo(0)
        }
        
        appstoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(25.ckValue())
            make.size.equalTo(appstoreButton.size)
        }
        
        shareButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appstoreButton.snp.bottom).offset(15.ckValue())
            make.size.equalTo(shareButton.size)
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    static func allheight(_ maxWidth: CGFloat) -> CGFloat {
        let titleHeight = self.titleStr.ocString.height(for: Self.titleFont, width: maxWidth - 40.ckValue() - 30.ckValue())
        
        let messageHeight = Self.messageStr.ocString.height(for: Self.messageFont, width: maxWidth - 40.ckValue())
        
        return 60.ckValue() + titleHeight + 20.ckValue() + messageHeight + Self.buttonCornerRadius * 4 + 40.ckValue() + 80.ckValue()
    }
    
    @objc func appstoreButtonClick() {
        self.delegate?.guideCommentDidScore(cell: self)
    }
    
    @objc func shareButtonClick() {
        self.delegate?.guideCommentDidShare(cell: self)
    }
    
    
    // MARK:  GET && SET
    weak var delegate: GuideRateReviewViewDelegate?
    
    static let titleStr = "  " + "We need your help".localStr() + "  "
    static let titleFont = UIFontBold(20.ckValue())
    
    static let messageStr = "If you think PassLock not bad, please give us a 5-star rating or recommend it to your friends. Thank you for your support!".localStr()
    static let messageFont = UIFontLight(15.ckValue())
    
    static let buttonCornerRadius = 23.ckValue()
    
    // MARK:  Lazy Init
    lazy var titleLabel: UILabel = {
        let sizeValue = 128.0 / 61
        let attach1 = NSTextAttachment()
        attach1.image = Reasource.named("maizi_left").flippedImage()
        attach1.bounds = CGRect(x: 0, y: -5.ckValue(), width: 15.ckValue(), height: 15.ckValue() * sizeValue)
        
        let attach2 = NSTextAttachment()
        attach2.image = Reasource.named("maizi_right").flippedImage()
        attach2.bounds = attach1.bounds
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3.ckValue()
        let attbutes: [NSAttributedString.Key: Any] = [.font: Self.titleFont, .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(attachment: attach1))
        attributedText.append(NSAttributedString(string: Self.titleStr, attributes: attbutes))
        attributedText.append(NSAttributedString(attachment: attach2))
        
        let view = UILabel()
        view.attributedText = attributedText
        view.textAlignment = .center
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3.ckValue()
        let attbutes: [NSAttributedString.Key: Any] = [.font: Self.messageFont, .foregroundColor: UIColor.white, .paragraphStyle: paragraphStyle]

        let attributedText = NSAttributedString(string: Self.messageStr, attributes: attbutes)
        
        let view = UILabel()
        view.attributedText = attributedText
        view.numberOfLines = 0
        return view
    }()
    
    lazy var appstoreButton: UIButton = {
        let font = UIFontBold(15.ckValue())
        let text = "Rate or review us".localStr()
        let textWidth = text.width(font) + 80.ckValue()
        
        let view = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: textWidth > 250.ckValue() ? textWidth : 250.ckValue(), height: Self.buttonCornerRadius * 2)))
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.backgroundColor = UIColor.white
        view.setTitleColor(self.backgroundColor, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Self.buttonCornerRadius
        view.addTarget(self, action: #selector(appstoreButtonClick), for: .touchUpInside)
        return view
    }()

    lazy var shareButton: UIButton = {
        let font = UIFontBold(15.ckValue())
        let text = "Share with friends".localStr()
        let view = UIButton(frame: appstoreButton.bounds)
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.backgroundColor = UIColor.white
        view.setTitleColor(self.backgroundColor, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Self.buttonCornerRadius
        view.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        return view
    }()
    
    
}
