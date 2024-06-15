//
//  PasswordUserPassCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordUserPassCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: PrivateBaseItemModel, itemType: PrivateCellItemType, isVisible: Bool) {
        var password = model.passwordModel?.passwords?.first?.password ?? ""
        if !isVisible {
            password = "●●●●●●"
        }
        
        var cellConfig = UIListContentConfiguration.valueCell()
        cellConfig.text = itemType == .userName ? "Username".localStr() : "Password".localStr()
        cellConfig.secondaryText = itemType == .userName ? (model.passwordModel?.accountName ?? "N/A") : password
        cellConfig.prefersSideBySideTextAndSecondaryText = true
        
        cellConfig.textProperties.font = UIFontLight(15.ckValue())
        cellConfig.secondaryTextProperties.font = UIFontLight(11.ckValue())
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
    }
    
    
}
