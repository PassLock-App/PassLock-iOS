//
//  ScreenPassCodeView.swift
//  PassLock
//
//  Created by Melo on 2024/6/6.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import LocalAuthentication

enum ScreenPassCode: Int {
    case code1 = 101
    case code2 = 102
    case code3 = 103
    case code4 = 104
    case code5 = 105
    case code6 = 106
    case code7 = 107
    case code8 = 108
    case code9 = 109
    case code0 = 110
    case codeFace = 111
    case codeDelete = 112
    
    func titleStr() -> String {
        switch self {
        case .code1: return "1"
        case .code2: return "2"
        case .code3: return "3"
        case .code4: return "4"
        case .code5: return "5"
        case .code6: return "6"
        case .code7: return "7"
        case .code8: return "8"
        case .code9: return "9"
        case .code0: return "0"
        case .codeFace: return ""
        case .codeDelete: return ""
        }
    }
    
    func iconImage() -> UIImage? {
        if self == .codeDelete {
            return UIImage(systemName: kaka_IsMacOS() ? "delete.left" : "delete.left.fill")
        }else if self == .codeFace {
            return LAContext().biometryType.supportIDImage()
        }else{
            return nil
        }
    }
}

protocol ScreenPassCodeViewDelegate: AnyObject {
    func screenPassCodeViewDidClick(codeView: ScreenPassCodeView, passCode: ScreenPassCode)
}

class ScreenPassCodeView: UIView {
    
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
        let numberArray: [ScreenPassCode] = [.code1, .code2, .code3, .code4, .code5, .code6, .code7, .code8, .code9, .codeFace, .code0, .codeDelete]
        let isDark = UITraitCollection.current.userInterfaceStyle == .dark
        
        if isDark {
            self.buttonBackColor = UIColor.tertiarySystemBackground
        }else{
            self.buttonBackColor = UIColor.secondarySystemBackground
        }
        
        let maxWidth = self.buttonSize.width * 3 + horizontalSpacing * 4
        let maxHeight = self.buttonSize.height * 4 + verticalSpacing * 6
        
        contentView.size = CGSize(width: maxWidth, height: maxHeight)
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(contentView.size)
        }
        
        let leftSpace = (maxHeight - self.buttonSize.width * 3 - self.horizontalSpacing * 2) / 2
        
        for i in 0..<4 {
            for j in 0..<3 {
                let index = i * 3 + j
                if index < numberArray.count {
                    let curCode = numberArray[index]
                    
                    let button = UIButton(type: .custom)
                    if curCode == .codeFace || curCode == .codeDelete {
                        var image = curCode.iconImage()
                        if kaka_IsMacOS() {
                            if curCode == .codeFace {
                                let size = CGSize(width: buttonSize.width * 0.618, height: buttonSize.height * 0.618)
                                image = image?.byResize(to: size, contentMode: .scaleAspectFit)?.withTintColor(appMainColor)
                            }else{
                                let sizeValue = image!.size.height / image!.size.width
                                let size = CGSize(width: buttonSize.width * 0.45, height: buttonSize.height * 0.45 * sizeValue)
                                image = image?.byResize(to: size, contentMode: .scaleAspectFit)
                            }
                        }
                        button.setImage(image, for: .normal)
                    }else{
                        button.setTitle(curCode.titleStr(), for: .normal)
                        button.titleLabel?.font = UIFontBold(24.ckValue())
                        button.setTitleColor(.label, for: .normal)
                    }
                    if curCode == .codeFace {
                        self.faceidButton = button
                    }
                    button.tag = curCode.rawValue
                    button.backgroundColor = buttonBackColor
                    button.addTarget(self, action: #selector(pinButtonClick(_:)), for: .touchUpInside)
                    button.layer.cornerRadius = buttonSize.width / 2
                    button.frame = CGRect(x: CGFloat(j) * (buttonSize.width + horizontalSpacing) + leftSpace,
                                          y: CGFloat(i) * (buttonSize.height + verticalSpacing),
                                          width: buttonSize.width,
                                          height: buttonSize.height)
                    contentView.addSubview(button)
                }
            }
        }
        
        let contentViewHeight = CGFloat(4) * buttonSize.height + CGFloat(3) * verticalSpacing
        let contentViewWidth = CGFloat(3) * buttonSize.width + CGFloat(2) * horizontalSpacing
        self.frame.size = CGSize(width: contentViewWidth, height: contentViewHeight)
    }
    
    private func preSetupContains() {
        
    }
    
    private func preSetupHandleBuness() {
    }
    
    @objc func pinButtonClick(_ sender: UIButton) {
        let code = ScreenPassCode(rawValue: sender.tag)
        self.delegate?.screenPassCodeViewDidClick(codeView: self, passCode: code ?? .codeDelete)
    }
    
    // MARK:  GET && SET
    
    var delegate: ScreenPassCodeViewDelegate?
    
    var horizontalSpacing: CGFloat = 33.ckValue()
    var verticalSpacing: CGFloat = 12.ckValue()
    
    let buttonSize: CGSize = CGSize(width: 68.ckValue(), height: 68.ckValue())
    
    var buttonBackColor: UIColor = UIColor.secondarySystemBackground {
        didSet {
            self.subviews.forEach { subView in
                subView.backgroundColor = buttonBackColor
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = self.backgroundColor
        }
    }
    
    // MARK:  Lazy Init
    var faceidButton: UIButton?

    lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = self.backgroundColor
        return view
    }()
    
}
