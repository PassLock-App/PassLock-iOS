//
//  SyncCloudButtonCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import AuthenticationServices

class SyncCloudButtonCell: UITableViewCell {
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
        self.selectionStyle = .default
    }
    
    func update(itemType: CloudCellItemType, count: Int) {
        
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.image = itemType.iconImage()
        cellConfig.text = itemType.titleStr()
        cellConfig.imageProperties.maximumSize = CGSize(width: 22.ckValue(), height: 22.ckValue())
        cellConfig.secondaryText = itemType == .passwordExtension ? nil : "\(count)"
        cellConfig.textProperties.color = UIColor.label
        cellConfig.prefersSideBySideTextAndSecondaryText = true
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        self.accessoryType = itemType == .passwordExtension ? .none : .disclosureIndicator
        if itemType == .passwordExtension {
            ASCredentialIdentityStore.shared.getState { storeStatus in
                DispatchQueue.main.async {
                    self.accessoryView = self.autofillView(storeStatus.isEnabled)
                }
            }
        }else{
            self.accessoryView = nil
        }
        
        self.contentConfiguration = cellConfig
    }
    
    func autofillView(_ isAutoFill: Bool) -> UIImageView {
        let image = isAutoFill ? Reasource.systemNamed("checkmark.seal.fill", color: appMainColor) : Reasource.systemNamed("exclamationmark.triangle.fill", color: UIColor.red)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.size = CGSizeMake(25.ckValue(), 25.ckValue())
        return view
    }
}
