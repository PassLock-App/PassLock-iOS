//
//  TransparencyTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/29.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit


class TransparencyTableCell: UITableViewCell {
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
    var itemType: TransparencyItemType? {
        didSet {
            guard let itemType = itemType else { return }
            
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.image = itemType.cellImage()
            cellConfig.text = itemType.titleStr()
            cellConfig.imageProperties.maximumSize = kaka_IsMacOS() ? CGSizeMake(22.ckValue(), 22.ckValue()) : CGSizeMake(25.ckValue(), 25.ckValue())
            cellConfig.textProperties.color = UIColor.label
            cellConfig.imageProperties.tintColor = appMainColor
            if kaka_IsMacOS() {
                cellConfig.textProperties.font = UIFontLight(15.ckValue())
            }
            
            if itemType == .openSource || itemType == .contactMail {
                cellConfig.prefersSideBySideTextAndSecondaryText = true
                cellConfig.secondaryText = itemType == .openSource ? "GitHub" : companyEmail
            }else{
                cellConfig.secondaryText = nil
            }
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            
            self.contentConfiguration = cellConfig
        }
    }
    
        
}
