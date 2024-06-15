//
//  PassCreateRuleView.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

enum KakaPasswordRule: Int {
    case numberCharacter = 0
    case onlyNumber = 1
    case onlyCharacter = 2
}

protocol PassCreateRuleViewDelegate: AnyObject {
    func passCreateRuleViewRuleChanged(isNumber: Bool, isChar: Bool, long: Int)
}

class PassCreateRuleView: UIView {
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
        
        self.addSubview(longLabel)
        self.addSubview(sliderView)
        self.addSubview(longNumLabel)
        self.addSubview(middleView)
        self.addSubview(numRuleView)
        self.addSubview(charRuleView)
    }
    
    private func preSetupContains() {
        sliderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.ckValue())
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(20.ckValue())
        }
        
        longLabel.snp.makeConstraints { make in
            make.trailing.equalTo(sliderView.snp.leading).offset(-10.ckValue())
            make.centerY.equalTo(sliderView)
            make.size.greaterThanOrEqualTo(0)
        }
        
        longNumLabel.snp.makeConstraints { make in
            make.leading.equalTo(sliderView.snp.trailing).offset(10.ckValue())
            make.centerY.equalTo(sliderView)
            make.size.greaterThanOrEqualTo(0)
        }
        
        middleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.leading.equalTo(numRuleView)
            make.trailing.equalTo(charRuleView)
            make.height.equalTo(numRuleView)
        }
        
        numRuleView.snp.makeConstraints { make in
            make.top.equalTo(sliderView.snp.bottom).offset(20.ckValue())
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(25.ckValue())
            make.bottom.equalToSuperview().inset(20.ckValue())
        }
        
        charRuleView.snp.makeConstraints { make in
            make.leading.equalTo(numRuleView.snp.trailing).offset(20.ckValue())
            make.centerY.equalTo(numRuleView)
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(numRuleView)
        }
        
    }
    
    private func preSetupHandleBuness() {
                
        self.sliderView.addBlock(for: .valueChanged) { [weak self] sender in
            guard let vSlider = sender as? UISlider else { return }
            guard let wSelf = self else { return }
            if wSelf.defaultLong == Int(vSlider.value) { return }
            wSelf.defaultLong = Int(vSlider.value)
            wSelf.delegate?.passCreateRuleViewRuleChanged(isNumber: wSelf.numRuleView.isSelected, isChar: wSelf.charRuleView.isSelected, long: wSelf.defaultLong)
        }
        
        self.backgroundColor = UIColor.systemFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(appModeSwitchChanged), name: NSNotification.Name(kAppThemeColorChangedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appModeSwitchChanged), name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
        self.appModeSwitchChanged()
    }
    
    @objc func appModeSwitchChanged() {
        sliderView.tintColor = appMainColor
    }
    
    @objc func ruleViewClick(_ sender: UIControl) {
        sender.isSelected = !sender.isSelected
        
        if sender == self.numRuleView {
            self.isNumber = sender.isSelected
        } else if sender == self.charRuleView {
            self.isCharacter = sender.isSelected
        }
        
        self.delegate?.passCreateRuleViewRuleChanged(isNumber: numRuleView.isSelected, isChar: charRuleView.isSelected, long: Int(sliderView.value))
    }
    
    // MARK: 🌹 GET && SET 🌹
    weak var delegate: PassCreateRuleViewDelegate?
    
    var defaultLong: Int = 16 {
        didSet {
            self.longNumLabel.text = "\(defaultLong)"
            self.sliderView.setValue(Float(defaultLong), animated: true)
        }
    }
    
    var isNumber: Bool = true {
        didSet {
            self.numRuleView.isSelected = isNumber
        }
    }
    
    var isCharacter: Bool = true {
        didSet {
            self.charRuleView.isSelected = isCharacter
        }
    }
    
    
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var longLabel: UILabel = {
        let view = UILabel()
        view.text = "length".localStr()
        view.font = UIFontLight(14.ckValue())
        view.textAlignment = .center
        view.textColor = UIColor.label
        return view
    }()

    lazy var sliderView: UISlider = {
        let view = UISlider()
        view.minimumValue = 10
        view.maximumValue = 100
        view.setValue(Float(defaultLong), animated: true)
        #if targetEnvironment(macCatalyst)
        #else
        view.setThumbImage(Reasource.named("slider_circle"), for: .normal)
        #endif
        return view
    }()
    
    lazy var longNumLabel: UILabel = {
        let view = UILabel()
        view.text = "\(defaultLong)"
        view.font = longLabel.font
        view.textAlignment = longLabel.textAlignment
        view.textColor = longLabel.textColor
        return view
    }()
    
    lazy var middleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var numRuleView: RuleView = {
        let view = RuleView()
        view.ruleLabel.text = "number".localStr()
        view.addTarget(self, action: #selector(ruleViewClick(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var charRuleView: RuleView = {
        let view = RuleView()
        view.ruleLabel.text = "character".localStr()
        view.addTarget(self, action: #selector(ruleViewClick(_:)), for: .touchUpInside)
        return view
    }()
    
}

class RuleView: UIControl {
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

        self.addSubview(selectBackView)
        self.addSubview(selectIconView)
        self.addSubview(ruleLabel)
    }
    
    private func preSetupContains() {
        selectBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(20.ckValue())
        }
        
        selectIconView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(selectBackView)
            make.size.equalTo(15.ckValue())
        }
        
        ruleLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectBackView.snp.trailing).offset(8.ckValue())
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.trailing.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        NotificationCenter.default.addObserver(self, selector: #selector(appModeSwitchChanged), name: NSNotification.Name(kAppThemeColorChangedKey), object: nil)
    }
    
    @objc func appModeSwitchChanged() {
        let selectImage = Reasource.named("rule_selected").withTintColor(appMainColor)
        selectIconView.image = selectImage
    }
    
    // MARK: 🌹 GET && SET 🌹
    override var isSelected: Bool {
        didSet {
            selectIconView.isHidden = !isSelected;
        }
    }
        
    // MARK: 🌹 Lazy Init 🌹
    lazy var ruleLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.label
        view.font = UIFontLight(15.ckValue())
        view.textAlignment = .center
        return view
    }()

    lazy var selectBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.ckValue()
        return view
    }()
    
    lazy var selectIconView: UIImageView = {
        let selectImage = Reasource.named("rule_selected").withTintColor(appMainColor)
        let view = UIImageView(image: selectImage)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
