//
//  DetialItemNotesViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/5.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class DetialItemNotesViewCell: UITableViewCell {
    
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
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel? {
        didSet {
            var cellConfig = UIListContentConfiguration.valueCell()
            cellConfig.text = self.model?.notes ?? "N/A"
            cellConfig.prefersSideBySideTextAndSecondaryText = true
            cellConfig.textProperties.font = UIFontLight(16.ckValue())
            cellConfig.textProperties.color = .label
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            
            self.contentConfiguration = cellConfig
        }
    }
    
    
}
