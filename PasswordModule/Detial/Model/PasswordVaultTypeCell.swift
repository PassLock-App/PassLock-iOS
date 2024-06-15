//
//  PasswordVaultTypeCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/1.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordVaultTypeCell: UITableViewCell {
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
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK:  GET && SET
    var model: PrivateBaseItemModel? {
        didSet {
            var cellConfig = self.defaultContentConfiguration()
            cellConfig.text = "Vault".localStr()
            if let bookType = AppICloudManager.shared.getPassbooks().filter({ $0.recordType == model?.recordType }).first {
                cellConfig.secondaryText = bookType.customName ?? bookType.recordType.nameStr()
            }else{
                cellConfig.secondaryText = model?.recordType.nameStr()
            }
            cellConfig.prefersSideBySideTextAndSecondaryText = true
            
            cellConfig.textProperties.font = UIFontLight(15.ckValue())
            cellConfig.secondaryTextProperties.font = UIFontLight(11.ckValue())
            cellConfig.secondaryTextProperties.color = appMainColor
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            
            self.contentConfiguration = cellConfig
            
        }
    }
    
}
