//
//  AttachPlusViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import KakaFoundation
import AppGroupKit

class AttachPlusViewCell: UITableViewCell {
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
        self.update()
    }
    
    func update() {
        let accessoryView = UIImageView(frame: CGRectMake(0, 0, 20.ckValue(), 20.ckValue()))
        accessoryView.contentMode = .scaleAspectFit
        accessoryView.image = Reasource.systemNamed("crown", color: appMainColor)
        self.accessoryView = accessoryView
        self.accessoryType = .none
        
        var cellConfig = UIListContentConfiguration.accompaniedSidebarCell()
        cellConfig.image = Reasource.systemNamed("paperclip.badge.ellipsis", color: appMainColor)
        cellConfig.text = "Add attachments".localStr()
        cellConfig.imageProperties.maximumSize = CGSizeMake(30.ckValue(), 30.ckValue())
        
        cellConfig.textProperties.color = UIColor.label
        cellConfig.textProperties.numberOfLines = 1
        cellConfig.textProperties.font = UIFontLight(15.ckValue())
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
        
    }
    
}
