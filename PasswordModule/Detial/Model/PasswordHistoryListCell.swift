//
//  PasswordHistoryListCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/6.
//

import KakaFoundation
import AppGroupKit

class PasswordHistoryListCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: PasswordListModel?, isCurrent: Bool) {
        guard let model = model else { return }
        let image1 = UIImage(systemName: "checkmark.seal.fill")?.withTintColor(appMainColor)
        let image2 = UIImage(systemName: "clock.arrow.circlepath")?.withTintColor(.orange)
        
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.image = isCurrent ? image1 : image2
        cellConfig.text = model.password
        cellConfig.secondaryText = model.formatCreateDate().dateString(ofStyle: .full)
        cellConfig.imageProperties.maximumSize = CGSizeMake(22.ckValue(), 22.ckValue())
        
        cellConfig.textProperties.color = UIColor.label
        cellConfig.textProperties.lineBreakMode = .byTruncatingMiddle
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.contentConfiguration = cellConfig
    }
    
}
