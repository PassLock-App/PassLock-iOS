//
//  AboutAppTableCell.swift
//  Hidden Camera Detector
//
//  Created by MarsTree on 2022/11/13.
//

import KakaUIKit
import AppGroupKit
import KakaFoundation

class AboutAppTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        self.selectionStyle = .none
        
        preSetupSubViews()
        preSetupContains()
        preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func preSetupSubViews() {
        contentView.addSubview(appIconbackColorView)
        appIconbackColorView.addSubview(appIconImageView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appVesionLabel)
    }
    
    func preSetupContains() {
                
        appIconbackColorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100.ckValue())
        }
        
        appIconImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        appNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appIconbackColorView.snp.bottom).offset(25.ckValue())
            make.centerX.equalTo(appIconbackColorView)
            make.size.greaterThanOrEqualTo(0)
        }
        
        appVesionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom).offset(6.ckValue())
            make.centerX.equalTo(appNameLabel)
            make.size.greaterThanOrEqualTo(0)
            make.bottom.equalToSuperview().offset(-5.ckValue())
        }
    }
    
    func preSetupHandleBuness() {
        
    }
  
    // MARK: 🌹 Lazy Init 🌹
    lazy var appIconbackColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 20.ckValue()
        view.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
  
    lazy var appIconImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: kaka_IsMacOS() ? "mac_logo" : "app_logo"))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = appIconbackColorView.layer.cornerRadius
        return view
    }()
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = "PassLock".localStr()
        label.font = UIFontBold(18.ckValue())
        label.textAlignment = .center
        return label
    }()
    
    lazy var appVesionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version " + (UIApplication.shared.appVersion ?? "1.0.0")
        label.font = UIFontLight(12.ckValue())
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
}
