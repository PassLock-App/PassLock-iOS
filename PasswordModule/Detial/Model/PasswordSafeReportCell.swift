//
//  PasswordSafeReportCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class PasswordSafeReportCell: UITableViewCell {
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
        self.selectionStyle = .none
    }
    
    // MARK:  GET && SET
    func update(model: PrivateBaseItemModel, healths: [PassHealthRick]) {
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.text = PrivateCellItemType.safeReport.formatTitle()
        
        cellConfig.image = PrivateCellItemType.safeReport.iconImage()
        cellConfig.imageProperties.maximumSize = CGSize(width: 22.ckValue(), height: 22.ckValue())
        cellConfig.textProperties.color = UIColor.label
        cellConfig.textProperties.numberOfLines = 1
        cellConfig.textProperties.font = UIFontLight(16.ckValue())
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        if model.isSyncCloud {
            guard let health = healths.first else {
                self.starView.setRating(5)
                return
            }
            
            switch health {
            case .allData:
                self.starView.setRating(5)
            case .securety:
                self.starView.setRating(5)
            case .easyGuess:
                self.starView.setRating(3)
            case .duplicate:
                self.starView.setRating(1)
            }
        }else{
            self.starView.setRating(1)
        }
        
        self.accessoryView = self.starView
        self.contentConfiguration = cellConfig
    }
    
    // MARK:  Lazy init
    lazy var starView: StarRatingView = {
        let view = StarRatingView(frame: CGRectMake(0, 0, 130.ckValue(), 30.ckValue()))
        view.setRating(0)
        return view
    }()
    
}
