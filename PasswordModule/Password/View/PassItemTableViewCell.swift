//
//  PassItemTableViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import SDWebImage

class PassItemTableViewCell: UITableViewCell {
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
        
    }
    
    private func preSetupContains() {
        
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK:  GET && SET
    func update(model: PrivateBaseItemModel, healthArray: [PassHealthRick]? = nil) {
        let imageSize = kaka_IsMacOS() ? CGSizeMake(25.ckValue(), 25.ckValue()) : CGSizeMake(30.ckValue(), 30.ckValue())
        let placeImage = model.storageType.systemIconImage()?.kaka_reSize(reSize: imageSize)?.withTintColor(appMainColor)

        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.image = placeImage
        cellConfig.text = model.customTitle
        cellConfig.secondaryText = model.showSecondDesc()
        cellConfig.imageProperties.maximumSize = imageSize
        cellConfig.textProperties.color = UIColor.label
        cellConfig.imageProperties.tintColor = appMainColor
        cellConfig.textProperties.numberOfLines = 1
        cellConfig.secondaryTextProperties.numberOfLines = 1
        cellConfig.imageProperties.cornerRadius = 6.ckValue()
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        cellConfig.textProperties.font = UIFontLight(15.ckValue())

        model.loadCoverImage(imageSize: imageSize) { newImage in
            cellConfig.image = newImage ?? placeImage
            self.contentConfiguration = cellConfig
        }
        
        if model.storageType == .password {
            self.accessoryView = model.isSyncCloud ? nil : self.localIconView
            self.accessoryType = model.isSyncCloud ? .disclosureIndicator : .none
            if model.isSyncCloud {
                let isStrong = healthArray?.first == .securety
                self.accessoryView = isStrong ? nil : self.healthWarnView
                self.accessoryType = .disclosureIndicator
            }else{
                self.accessoryView = self.localIconView
                self.accessoryType = .none
            }
            
        }else if model.storageType == .photoVault {
            self.accessoryView = model.isSyncCloud ? self.attachIconView : self.localIconView
            self.accessoryType = .none
        }else if model.storageType == .secretNotes {
            self.accessoryView = model.isSyncCloud ? nil : self.localIconView
            self.accessoryType = model.isSyncCloud ? .disclosureIndicator : .none
        }else{
            self.accessoryView = nil
            self.accessoryType = .disclosureIndicator
        }
        
        self.contentConfiguration = cellConfig
        
    }
    
    // MARK:  Lazy init
    let accessorySize = CGSize(width: 20.ckValue(), height: 20.ckValue())
    
    lazy var attachIconView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("paperclip.badge.ellipsis", color: appMainColor))
        view.contentMode = .scaleAspectFit
        view.size = accessorySize
        return view
    }()
    
    lazy var localIconView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("icloud.slash", color: UIColor.orange))
        view.contentMode = .scaleAspectFit
        view.size = accessorySize
        return view
    }()
    
    lazy var cloudIconView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("checkmark.icloud", color: UIColor.systemGreen))
        view.contentMode = .scaleAspectFit
        view.size = accessorySize
        return view
    }()
    
    lazy var healthWarnView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("exclamationmark.shield", color: .orange))
        view.contentMode = .scaleAspectFit
        view.size = accessorySize
        return view
    }()
    
}
