//
//  DetialItemActionViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/1/10.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit



class DetialItemActionViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateItemType(model: PrivateBaseItemModel, itemType: PrivateCellItemType) {
        var cellConfig = UIListContentConfiguration.valueCell()
        cellConfig.image = itemType.iconImage(model.isCollection)
        cellConfig.text = itemType.formatTitle(model.isCollection)
        cellConfig.imageProperties.maximumSize = CGSizeMake(22.ckValue(), 22.ckValue())
        cellConfig.prefersSideBySideTextAndSecondaryText = true
        cellConfig.textProperties.font = UIFontLight(16.ckValue())
        cellConfig.textProperties.color = .label
        
        if itemType == .syncAction {
            self.accessoryView = self.cloudIconView(model.isSyncCloud)
        }else{
            self.accessoryView = nil
        }
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
    }
    
    func cloudIconView(_ isCloud: Bool) -> UIImageView {
        let cloudImgView = UIImageView(image: Reasource.systemNamed(isCloud ? "checkmark.icloud" : "icloud.slash", color: isCloud ? appMainColor : UIColor.orange))
        cloudImgView.contentMode = .scaleAspectFit
        cloudImgView.size = CGSizeMake(22.ckValue(), 22.ckValue())
        return cloudImgView
    }
    
}
