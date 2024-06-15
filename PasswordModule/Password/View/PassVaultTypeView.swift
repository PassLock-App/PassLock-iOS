//
//  PassVaultTypeView.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PassVaultTypeView: UIView {
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
        self.addSubview(backView)
        self.addSubview(passTypeLabel)
        self.addSubview(arrowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft

        let passWidth = self.recordModel.showTitle().width(passFont)
        let arroWidth = 16.ckValue()
        let leadSpace = 15.ckValue()
        let innerSpace = 5.ckValue()
        
        if isRTL {
            arrowView.frame = CGRectMake((self.width - passWidth) / 2 - (arroWidth + innerSpace) / 2, (self.height - arroWidth) / 2, arroWidth, arroWidth)
            passTypeLabel.frame = CGRectMake(CGRectGetMaxX(arrowView.frame) + innerSpace, (self.height - passFont.lineHeight) / 2, passWidth, passFont.lineHeight)
            backView.frame = CGRectMake(arrowView.left - leadSpace, 0, passWidth + 5.ckValue() + arroWidth + leadSpace * 2, self.height)
        }else{
            passTypeLabel.frame = CGRectMake((self.width - passWidth) / 2 - (arroWidth + innerSpace) / 2, (self.height - passFont.lineHeight) / 2, passWidth, passFont.lineHeight)
            arrowView.frame = CGRectMake(CGRectGetMaxX(passTypeLabel.frame) + innerSpace, (self.height - arroWidth) / 2, arroWidth, arroWidth)
            backView.frame = CGRectMake(passTypeLabel.left - leadSpace, 0, passWidth + 5.ckValue() + arroWidth + leadSpace * 2, self.height)
        }
        
    }

    
    private func preSetupContains() {
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = UIColor.clear
        let bookModel = AppICloudManager.shared.currentPassbook
        self.recordModel = bookModel
        
    }
    
    // MARK:  GET && SET
    
    let passFont = UIFont.boldSystemFont(ofSize: 14.ckValue())
    
    var recordModel = AppICloudManager.shared.currentPassbook {
        didSet {
            passTypeLabel.text = recordModel.showTitle()
            self.layoutSubviews()
        }
    }
    
    // MARK:  Lazy init
    lazy var backView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.systemFill.cgColor
        view.layer.borderWidth = 1.ckValue()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = self.frame.size.height / 2
        return view
    }()
    
    lazy var passTypeLabel: UILabel = {
        let view = UILabel()
        view.font = passFont
        view.textAlignment = .center
        view.textColor = UIColor.label
        return view
    }()
    
    lazy var arrowView: UIImageView = {
        let arrowImage = Reasource.systemNamed("chevron.forward.circle.fill", color: UIColor.label).flippedImage()
        let view = UIImageView(image: arrowImage)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
