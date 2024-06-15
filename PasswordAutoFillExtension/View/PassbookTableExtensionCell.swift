//
//  PassbookTableExtensionCell.swift
//  PasswordAutoFillExtension
//
//  Created by Melo on 2023/11/29.
//


import KakaFoundation
import AppGroupKit
import SDWebImage

class PassbookTableExtensionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: PrivateBaseItemModel) {
        let imageSize = kaka_IsMacOS() ? CGSizeMake(25.ckValue(), 25.ckValue()) : CGSizeMake(30.ckValue(), 30.ckValue())
        let placeImage = model.storageType.systemIconImage()?.kaka_reSize(reSize: imageSize)?.withTintColor(appMainColor)

        var cellConfig = UIListContentConfiguration.sidebarSubtitleCell()
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

        model.loadCoverImage(imageSize: imageSize) { newImage in
            cellConfig.image = newImage ?? placeImage
            self.contentConfiguration = cellConfig
        }
        
        if (model.passwordModel?.passwords?.count ?? 0) > 1 {
            self.accessoryType = .none
            self.accessoryView = self.moreIconView
        }else{
            self.accessoryType = .disclosureIndicator
            self.accessoryView = nil
        }
        
        self.contentConfiguration = cellConfig
        
    }
    
    lazy var moreIconView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "ellipsis.rectangle")?.withTintColor(.secondaryLabel))
        view.contentMode = .scaleAspectFit
        view.size = CGSizeMake(22.ckValue(), 22.ckValue())
        return view
    }()
    
}
