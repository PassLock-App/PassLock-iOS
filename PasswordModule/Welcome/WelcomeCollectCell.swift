//
//  WelcomeCollectCell.swift
//  PassLock
//
//  Created by Melo on 2023/9/16.
//

import KakaFoundation
import AppGroupKit
import KakaUIKit

class WelcomeCollectCell: UICollectionViewCell {
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
        self.backgroundColor = .clear
        contentView.addSubview(welcomeImgView)
        contentView.addSubview(colorView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(descLabel)
    }
    
    private func preSetupContains() {
        welcomeImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if kaka_IsMacOS() {
                make.top.equalToSuperview().offset(50.ckValue())
                make.size.equalTo(300)
            }else{
                make.bottom.equalTo(contentView.snp.centerY)
                make.width.equalToSuperview().multipliedBy(kaka_IsiPad() ? 0.5 : 0.75)
                make.height.equalTo(welcomeImgView.snp.width)
            }
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeImgView.snp.bottom).offset(35.ckValue())
            make.size.equalTo(30)
        }
        
        colorView.snp.makeConstraints { make in
            make.centerX.equalTo(welcomeLabel)
            make.top.equalTo(welcomeLabel).offset(10.ckValue())
            make.leading.equalTo(welcomeLabel).offset(-3.ckValue())
            make.bottom.equalTo(welcomeLabel).offset(3.ckValue())
        }
        
        descLabel.snp.makeConstraints { make in
            make.width.equalTo(welcomeImgView)
            make.top.equalTo(welcomeLabel.snp.bottom).offset(30.ckValue())
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    let leadingSpase = kaka_IsMacOS() ? 80.ckValue() : 20.ckValue()
    
    // MARK: 🌹 GET && SET 🌹
    var model: WelcomeInfoModel? {
        didSet {
            guard let vModel = model else { return }
            
            self.backgroundColor = vModel.backColor
            
            welcomeLabel.text = vModel.title
            welcomeLabel.font = self.calculateMaxFontSize(content: vModel.title, maxWidth: self.bounds.width - leadingSpase * 2 - 5, maxFont: 30)
            descLabel.attributedText = self.descAttbuteStr(content: vModel.welcomeStr, alignment: .center)
            welcomeImgView.image = Reasource.named(vModel.iconName)
            
            let welcomeSize = CGSize(width: vModel.title.width(welcomeLabel.font) + 5, height: welcomeLabel.font.lineHeight)
            welcomeLabel.snp.updateConstraints { make in
                make.size.equalTo(welcomeSize)
            }
            contentView.layoutIfNeeded()
        }
    }
    
    func descAttbuteStr(content: String, alignment: NSTextAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left) -> NSAttributedString {
        
        let paramStyle = NSMutableParagraphStyle()
        paramStyle.lineSpacing = 3.ckValue()
        paramStyle.alignment = alignment
        
        let attributes = [NSAttributedString.Key.font: UIFontBold(17.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.rgb(102, 99, 116), NSAttributedString.Key.paragraphStyle: paramStyle]
        
        let attbuteStr = NSAttributedString(string: content, attributes: attributes)
        
        return attbuteStr
    }
    
    func calculateMaxFontSize(content: String, maxWidth: CGFloat, maxFont: CGFloat) -> UIFont {
        
        while true {
            let estimatedWidth = content.ocString.width(for: UIFontBold(fontSize))
            
            if estimatedWidth <= maxWidth {
                break
            }
            
            fontSize -= 1
        }
        
        return UIFontBold(fontSize > maxFont ? maxFont : fontSize)
    }
    
    // MARK: 🌹 Lazy init 🌹
    lazy var welcomeImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(255, 165, 0)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.ckValue()
        return view
    }()
    
    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = UIFontBold(30.ckValue())
        view.textColor = UIColor.rgb(19, 20, 21)
        view.textAlignment = .center
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

}
