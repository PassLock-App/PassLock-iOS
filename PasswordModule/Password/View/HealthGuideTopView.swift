//
//  HealthGuideTopView.swift
//  PassLock
//
//  Created by Melo on 2023/11/6.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit
import MarqueeLabel

class HealthGuideTopView: UIView {

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
        self.addSubview(contentView)
        contentView.addSubview(statusView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(closeButton)
    }
    
    private func preSetupContains() {
        
        contentView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(kaka_IsiPhone() ? kaka_safeAreaInsets().top : 0)
        }
        
        statusView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40.ckValue())
            make.leading.equalTo(20.ckValue())
        }
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15.ckValue())
            make.centerY.equalTo(statusView)
            make.size.equalTo(closeButton.size)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusView.snp.trailing).offset(10.ckValue())
            make.centerY.equalTo(statusView)
            make.trailing.equalTo(closeButton.snp.leading).offset(-6.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK: 🌹 GET && SET 🌹
    func update(healthRisk: PassHealthRick, count: Int) {
        self.removeVerticalGradientLayer()
        let colors = [healthRisk.healthColor().cgColor, UIColor.rgb(49, 54, 87).cgColor]
        
        self.drawVerticalGradientLayer(colors)
        self.statusLabel.text = healthRisk.descStr(count)
        self.statusView.image = healthRisk.statusImage()
    }
    
    var closeCallBack: (()->Void)?
    
    
    @objc func closeButtonClick() {
        UIView.animate(withDuration: 0.25) { [weak self] () in
            guard let wSelf = self else { return }
            wSelf.top = -wSelf.height
        } completion: { [weak self] finish in
            self?.closeCallBack?()
            self?.removeFromSuperview()
        }

    }
    
    // MARK: 🌹 Lazy init 🌹
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var statusLabel: MarqueeLabel = {
        let view = MarqueeLabel()
        view.font = UIFontBold(14.ckValue())
        view.textColor = UIColor.white
        view.fadeLength = 0.5
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.type = PhoneSetManager.isArabicLanguage() ? .rightLeft : .leftRight
        return view
    }()

    lazy var statusView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let size = 30.ckValue()
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = size / 2
        view.contentHorizontalAlignment = .center
        view.setImage(Reasource.systemNamed("xmark.circle", color: UIColor.white), for: .normal)
        view.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return view
    }()
    
}
