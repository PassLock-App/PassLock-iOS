//
//  MacCurrentVaultTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit

class MacCurrentVaultTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        contentView.addSubview(vaultBackView)
        contentView.addSubview(vaultIconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(arrowView)
    }
    
    private func preSetupContains() {
        
        arrowView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5.ckValue())
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.size)
        }
        
        vaultBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5.ckValue())
            make.centerY.equalToSuperview()
            make.size.equalTo(vaultBackView.layer.cornerRadius * 2)
        }
        
        vaultIconView.snp.makeConstraints { make in
            make.center.equalTo(vaultBackView)
            make.size.equalTo(vaultBackView).multipliedBy(0.68)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(vaultBackView.snp.trailing).offset(10.ckValue())
            make.bottom.equalTo(vaultBackView.snp.centerY)
            make.trailing.equalTo(arrowView.snp.leading).offset(-5.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(arrowView.snp.leading).offset(-5.ckValue())
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        self.accessoryType = .none
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8.ckValue()
        

        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: kICloudPassBookChangedKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: kDeletePrivateItemKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: kSaveOrUpdateAccountKey), object: nil)
        
    }
    
    // MARK:  GET && SET
    @objc func update() {
        
        let currentVault = AppICloudManager.shared.currentPassbook
        let itemCount = SandboxFileManager.shared.readPrivateItemModels(recordType: currentVault.recordType, itemType: .allItem).count
        
        vaultIconView.image = currentVault.recordType.recordIconImage().withTintColor(appMainColor)
        nameLabel.text = currentVault.showTitle()
        descLabel.text = String(format: "Total %@ Items".localStr(), "\(itemCount)")
        contentView.layoutIfNeeded()
    }
    
    // MARK:  Lazy Init
    
    lazy var vaultBackView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.systemFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20.ckValue()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var vaultIconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = UIFontLight(12.ckValue())
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.text = UIDevice.current.name
        view.textColor = UIColor.label
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = UIFontLight(9.ckValue())
        view.textAlignment = nameLabel.textAlignment
        view.textColor = UIColor.secondaryLabel
        return view
    }()
    
    lazy var arrowView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("chevron.right", color: UIColor.secondaryLabel).flippedImage())
        view.bounds = CGRectMake(0, 0, 15.ckValue(), 15.ckValue())
        view.contentMode = .scaleAspectFit
        return view
    }()
}
