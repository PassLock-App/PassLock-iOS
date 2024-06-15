//
//  PasswordTableFootView.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordTableFootView: UIView {
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
        self.addSubview(countLabel)
        self.addSubview(statusLabel)
        self.addSubview(arrowView)
        self.addSubview(greenView)
    }
    
    private func preSetupContains() {
        countLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(15.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countLabel.snp.bottom).offset(2.ckValue())
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
        }
        
        greenView.snp.makeConstraints { make in
            make.trailing.equalTo(statusLabel.snp.leading).offset(-5.ckValue())
            make.centerY.equalTo(statusLabel)
            make.size.equalTo(greenView.layer.cornerRadius * 2)
        }
        
        arrowView.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel.snp.bottom).offset(1.ckValue())
            make.trailing.equalToSuperview().inset(20.ckValue())
            make.size.equalTo(16.ckValue())
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .clear
        
        self.isUserInteractionEnabled = true
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(clickTapClick))
        self.addGestureRecognizer(clickTap)
    }
    
    @objc func clickTapClick() {
        if self.statusLabel.isHidden { return }
        self.onClickCallBack?()
    }
    
    static func allHeight(maxWidth: CGFloat, status: SyncCloudStatus?) -> CGFloat {

        guard let syncStatus = status else { return 0 }
        
        let statusHeight = syncStatus.syncStatusStr().ocString.height(for: UIFontLight(12.ckValue()), width: maxWidth - 40.ckValue())
        return 15.ckValue() + UIFontLight(15.ckValue()).lineHeight + 2.ckValue() + statusHeight + 30.ckValue()
    }
    
    // MARK:  GET && SET
    var onClickCallBack: (()->Void)?
    
    func update(dataArray: [PrivateBaseItemModel], viewModel: PasswordViewModel) {
        
        self.countLabel.isHidden = dataArray.count == 0
        self.arrowView.isHidden = dataArray.count == 0
        self.statusLabel.isHidden = dataArray.count == 0
        
        self.isUserInteractionEnabled = false
        
        guard let syncStatus = viewModel.syncStatus else { return }
        
        self.isUserInteractionEnabled = true
        
        countLabel.text = String(format: "Total %@ Items".localStr(), "\(dataArray.count)")
        
        statusLabel.text = syncStatus.syncStatusStr()
        statusLabel.textColor = syncStatus.syncStatusColor()
        greenView.isHidden = syncStatus != .completion || dataArray.count == 0
    }
    
    // MARK:  Lazy init
    lazy var countLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontLight(15.ckValue())
        view.textColor = UIColor.label
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFontLight(12.ckValue())
        view.textColor = UIColor.secondaryLabel
        view.textAlignment = .center
        return view
    }()
    
    lazy var arrowView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("chevron.forward", color: .secondaryLabel).flippedImage())
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var greenView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 6.ckValue(), 6.ckValue()))
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3.ckValue()
        view.backgroundColor = UIColor.systemGreen
        return view
    }()
}
