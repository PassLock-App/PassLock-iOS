//
//  GuideRecommendHeadView.swift
//  PassLock
//
//  Created by Melo on 2023/8/11.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import YYText

protocol GuideRecommendHeadViewDelegate: AnyObject {
    
    func guideDeveViewClickIconFinder(view: GuideRecommendHeadView)
    
    func guideDeveViewClickDeveloper(view: GuideRecommendHeadView)
}

class GuideRecommendHeadView: UIView {
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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12.ckValue()
        self.backgroundColor = UIColor.rgb(181, 228, 254)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        self.addSubview(freeTralButton)
    }
    
    private func preSetupContains() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15.ckValue())
            make.centerX.equalToSuperview()
            make.leading.equalTo(15.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        freeTralButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(20.ckValue())
            make.size.equalTo(freeTralButton.size)
            make.bottom.equalToSuperview().inset(kaka_safeAreaInsets().bottom/2 + 10.ckValue())
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK: 🌹 GET && SET 🌹
    weak var delegate: GuideRecommendHeadViewDelegate?
    
    
    // MARK: 🌹 Lazy Init 🌹
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontBold(20.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.rgb(0, 16, 29)
        view.numberOfLines = 0
        return view
    }()
    
    lazy var descLabel: YYLabel = {
        let view = YYLabel()
        view.attributedText = self.contactAttbuteStr()
        view.numberOfLines = 0
        view.preferredMaxLayoutWidth = kaka_screen_width() - 30.ckValue()
        return view
    }()
    
    lazy var freeTralButton: UIButton = {
        let font = UIFontLight(15.ckValue())
        let view = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: text.width(font) + 80.ckValue(), height: 44.ckValue())))
        view.setTitle(text, for: .normal)
        view.titleLabel?.font = font
        view.backgroundColor = UIColor.systemBlue
        view.setTitleColor(UIColor.white, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 22.ckValue()
        view.addTarget(self, action: #selector(contactDeveloperClick), for: .touchUpInside)
        return view
    }()

    // 联系开发者
    @objc func contactDeveloperClick() {
        self.delegate?.guideDeveViewClickDeveloper(view: self)
    }
    
    func contactAttbuteStr() -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.ckValue()
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFontLight(17.ckValue()), NSAttributedString.Key.foregroundColor: UIColor.rgb(7, 17, 29), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let range1 = sumStr.ocString.range(of: str1)
        
        let attributedText = NSMutableAttributedString(string: sumStr, attributes: attributes)
        attributedText.yy_setUnderlineStyle(NSUnderlineStyle.single, range: range1)
        attributedText.yy_setFont(UIFontBold(17.ckValue()), range: range1)
        attributedText.yy_setTextHighlight(range1, color: UIColor.systemBlue, backgroundColor: .none) { [weak self] (view, attr, range, rect) in
            guard let wSelf = self else { return }
            wSelf.delegate?.guideDeveViewClickIconFinder(view: wSelf)
        }
        return attributedText
    }
}
