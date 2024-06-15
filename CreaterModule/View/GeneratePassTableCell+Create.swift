//
//  GeneratePassTableCell+Create.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/3/25.
//  Copyright © 2023 PassLock. All rights reserved.
//

import KakaUIKit
import KakaFoundation
import Toast_Swift

extension GeneratePassTableCell: CAAnimationDelegate {
    
    @objc func createPassword() {
        
        guard let pass = self.passwordView.passLabel.text, pass.count > 0 else {
            self.startCreatePassword()
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 0.35
        animation.fillMode = .forwards
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        self.retryButton.layer.add(animation, forKey: nil)
    }
    
    @objc func copypassButtonClick(_ sender: UIButton) {
        UIPasteboard.general.string = self.passwordView.passLabel.text?.removeSpace()

        self.passwordView.copyedView.backgroundColor = UIColor.rgb(159, 254, 191)
        self.passwordView.copyLabel.text = "Copied Successful".localStr()
        
        self.viewController?.view.makeToast("Copied Successful".localStr())
                
        if let password = self.passwordView.passLabel.attributedText?.string {
            self.delegate?.passCellCopyed(cell: self, password: password)
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.copypassButton.kaka_playShakeAnim()
        self.startCreatePassword()
    }
}

extension GeneratePassTableCell: PassCreateRuleViewDelegate {
    func passCreateRuleViewRuleChanged(isNumber: Bool, isChar: Bool, long: Int) {
        self.startCreatePassword()
    }
}

extension GeneratePassTableCell {
    
    func startCreatePassword() {
        self.passwordView.copyLabel.text = self.passwordView.copy1
        self.passwordView.copyedView.backgroundColor = UIColor.rgb(254, 203, 109)
        
        let passwordStr: NSAttributedString!
        switch self.passFormat {
        case .randomPass: passwordStr = self.createRandomPassword()
        case .easyRemember: passwordStr = self.createEasyRememberPassword()
        case .pinPassCode: passwordStr = self.createPinPassword()
        }
        
        self.passwordView.passLabel.attributedText = passwordStr
        self.layoutIfNeeded()
        
        self.delegate?.passCellCreatedSuccess(cell: self, password: passwordStr.string)
    }
    
    private func createRandomPassword() -> NSAttributedString {
        
        let password =
        self.passGenarator.generatePassword(length: ruleView.defaultLong , includeNumbers: ruleView.isNumber, includeSpecialChars: ruleView.isCharacter)
        
        return password
        
    }
    
    private func createEasyRememberPassword() -> NSAttributedString {
        let password = passGenarator.generateMemorablePasswordWithWords(length: ruleView.defaultLong, includeNumbers: ruleView.isNumber, includeSpecialChars: ruleView.isCharacter)
        
        return password
    }

    private func createPinPassword() -> NSAttributedString {
        
        let sourceStr = "0123456789"
        
        let resultStr = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3.ckValue()
        
        let attbutes: [NSAttributedString.Key: Any] = [.font: passwordView.passLabel.font!, .foregroundColor: appMainColor,.paragraphStyle: paragraphStyle]
        
        for i in 0..<self.ruleView.defaultLong {
            
            var oneStr: String = sourceStr.ocString.substring(with: NSMakeRange(Int(arc4random()) % sourceStr.count, 1))
            if i < self.ruleView.defaultLong - 1 {
                oneStr.append(" ")
            }
            
            resultStr.append(NSAttributedString(string: oneStr, attributes: attbutes))
        }
        
        return resultStr
    }
    
}

