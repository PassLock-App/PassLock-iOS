//
//  PasscodeResultView.swift
//  PassLock
//
//  Created by Melo on 2024/6/6.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasscodeResultView: UIView {
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
        self.addSubview(lineView1)
        self.addSubview(lineView2)
        self.addSubview(lineView3)
        self.addSubview(lineView4)
        
        self.addSubview(numberLabel1)
        self.addSubview(numberLabel2)
        self.addSubview(numberLabel3)
        self.addSubview(numberLabel4)
    }
    
    private func preSetupContains() {
        let lineWidth = (self.width - space * 3) / 4
        lineView1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(lineWidth)
            make.height.equalTo(3.ckValue())
        }
        
        lineView2.snp.makeConstraints { make in
            make.leading.equalTo(lineView1.snp.trailing).offset(space)
            make.centerY.equalToSuperview()
            make.size.equalTo(lineView1)
        }
        
        lineView3.snp.makeConstraints { make in
            make.leading.equalTo(lineView2.snp.trailing).offset(space)
            make.centerY.equalToSuperview()
            make.size.equalTo(lineView1)
        }
        
        lineView4.snp.makeConstraints { make in
            make.leading.equalTo(lineView3.snp.trailing).offset(space)
            make.centerY.equalToSuperview()
            make.size.equalTo(lineView1)
        }
        
        numberLabel1.snp.makeConstraints { make in
            make.center.equalTo(lineView1)
            make.size.greaterThanOrEqualTo(0)
        }
        
        numberLabel2.snp.makeConstraints { make in
            make.center.equalTo(lineView2)
            make.size.greaterThanOrEqualTo(0)
        }
        
        numberLabel3.snp.makeConstraints { make in
            make.center.equalTo(lineView3)
            make.size.greaterThanOrEqualTo(0)
        }
        
        numberLabel4.snp.makeConstraints { make in
            make.center.equalTo(lineView4)
            make.size.greaterThanOrEqualTo(0)
        }
    }
    
    private func preSetupHandleBuness() {
    }
    
    func addPasscode(_ passCode: ScreenPassCode) -> String? {
        guard let code1 = self.numberLabel1.text else {
            self.numberLabel1.text = passCode.titleStr()
            self.lineView1.isHidden = true
            self.passcodeStr = passCode.titleStr()
            return self.passcodeStr
        }
                
        guard let code2 = self.numberLabel2.text else {
            self.numberLabel2.text = passCode.titleStr()
            self.lineView2.isHidden = true
            self.passcodeStr = code1 + passCode.titleStr()
            return self.passcodeStr
        }
        
        self.passcodeStr = code1 + code2
        
        guard let code3 = self.numberLabel3.text else {
            self.numberLabel3.text = passCode.titleStr()
            self.lineView3.isHidden = true
            self.passcodeStr = code1 + code2 + passCode.titleStr()
            return self.passcodeStr
        }
        
        self.passcodeStr = code1 + code2 + code3
        
        guard let code4 = self.numberLabel4.text else {
            self.numberLabel4.text = passCode.titleStr()
            self.lineView4.isHidden = true
            self.passcodeStr = code1 + code2 + code3 + passCode.titleStr()
            return self.passcodeStr
        }
        
        self.passcodeStr = code1 + code2 + code3 + code4
        return self.passcodeStr
    }
    
    func deletePasscode() {
        if let _ = self.numberLabel4.text {
            self.numberLabel4.text = nil
            self.lineView4.isHidden = false
            self.passcodeStr?.removeLast()
            return
        }
        
        if let _ = self.numberLabel3.text {
            self.numberLabel3.text = nil
            self.lineView3.isHidden = false
            self.passcodeStr?.removeLast()
            return
        }
        
        if let _ = self.numberLabel2.text {
            self.numberLabel2.text = nil
            self.lineView2.isHidden = false
            self.passcodeStr?.removeLast()
            return
        }
        
        if let _ = self.numberLabel1.text {
            self.numberLabel1.text = nil
            self.lineView1.isHidden = false
            self.passcodeStr = nil
            return
        }
        
    }
    
    func clearAllPasscode() {
        self.passcodeStr = nil
        
        self.lineView1.isHidden = false
        self.lineView2.isHidden = false
        self.lineView3.isHidden = false
        self.lineView4.isHidden = false
        
        self.numberLabel1.text = nil
        self.numberLabel2.text = nil
        self.numberLabel3.text = nil
        self.numberLabel4.text = nil
    }
    
    // MARK:  GET && SET
    
    var passcodeStr: String?
    
    let space = 20.ckValue()
    
    // MARK:  Lazy Init
        
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = lineView1.backgroundColor
        return view
    }()
    
    lazy var lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = lineView1.backgroundColor
        return view
    }()
    
    lazy var lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = lineView1.backgroundColor
        return view
    }()
    
    lazy var numberLabel1: UILabel = {
        let view = UILabel()
        view.font = UIFontBold(30.ckValue())
        view.textAlignment = .center
        view.textColor = .label
        return view
    }()
    
    lazy var numberLabel2: UILabel = {
        let view = UILabel()
        view.font = numberLabel1.font
        view.textAlignment = .center
        view.textColor = .label
        return view
    }()
    
    lazy var numberLabel3: UILabel = {
        let view = UILabel()
        view.font = numberLabel1.font
        view.textAlignment = .center
        view.textColor = .label
        return view
    }()
    
    lazy var numberLabel4: UILabel = {
        let view = UILabel()
        view.font = numberLabel1.font
        view.textAlignment = .center
        view.textColor = .label
        return view
    }()
}

