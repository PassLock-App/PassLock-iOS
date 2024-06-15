//
//  AddAttachTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import KakaFoundation
import AppGroupKit

class AddAttachTableCell: UITableViewCell {
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
    private var itemModel: PrivateBaseItemModel?
    
    func update(itemModel: PrivateBaseItemModel?, fileModel: SingleFileModel?, index: Int) {
        self.itemModel = itemModel
        let fileImage = fileModel?.assetImage() ?? Reasource.systemNamed("icloud.and.arrow.down", color: UIColor.lightGray)
        
        let sizeIntKB = fileModel?.assetModel?.fileSize() ?? 0
        
        var cellConfig = UIListContentConfiguration.accompaniedSidebarCell()
        cellConfig.image = fileImage
        cellConfig.text = "Attachments".localStr() + "\(index)"
        cellConfig.secondaryText = sizeIntKB.fileSizeString()
        cellConfig.imageProperties.maximumSize = CGSizeMake(60.ckValue(), 60.ckValue())
        cellConfig.imageProperties.reservedLayoutSize = CGSizeMake(60.ckValue(), 60.ckValue())
        
        cellConfig.textProperties.color = UIColor.label
        cellConfig.textProperties.numberOfLines = 1
        cellConfig.textProperties.font = UIFontLight(15.ckValue())
        cellConfig.secondaryTextProperties.font = UIFontLight(11.ckValue())
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
        
    }
    
        
}
