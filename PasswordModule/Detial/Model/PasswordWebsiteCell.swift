//
//  PasswordWebsiteCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordWebsiteCell: UITableViewCell {
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
        
    }
    
    // MARK:  GET && SET
    func update(model: PrivateBaseItemModel, itemType: PrivateCellItemType) {
        
        let isWebsite = model.passwordModel?.websiteModel?.dominUrlStr() != nil
        
        if itemType == .websiteURL {
            var cellConfig = UIListContentConfiguration.valueCell()
            cellConfig.text = model.passwordModel?.websiteModel?.dominUrlStr() ?? "Setting up a website".localStr()
            cellConfig.textProperties.color = isWebsite ? UIColor.label : appMainColor
            cellConfig.textProperties.font = UIFontLight(15.ckValue())
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            
            self.accessoryView = isWebsite ? self.safariImgView : nil
            self.accessoryType = isWebsite ? .none : .disclosureIndicator
            self.selectionStyle = .default
            self.contentConfiguration = cellConfig
        }else{
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.text = "Change password on website".localStr()
            
            cellConfig.textProperties.font = UIFontLight(15.ckValue())
            cellConfig.textProperties.color = isWebsite ? appMainColor : UIColor.secondaryLabel
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15                
            
            self.accessoryView = nil
            self.accessoryType = isWebsite ? .disclosureIndicator : .none
            self.selectionStyle = isWebsite ? .default : .none
            self.contentConfiguration = cellConfig
        }
    }
    
    // MARK:  Lazy init
    lazy var safariImgView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("safari", color: .secondaryLabel))
        view.contentMode = .scaleAspectFit
        view.size = CGSizeMake(20.ckValue(), 20.ckValue())
        return view
    }()
}
