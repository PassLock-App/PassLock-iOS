//
//  UserTableViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import AuthenticationServices

class UserTableViewCell: UITableViewCell {
    
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
    
    @objc func colorWellValueChanged(_ sender: UIColorWell) {
        guard let selectedColor = sender.selectedColor else { return }
        
        debugPrint("selectedColor = \(selectedColor.hex16String)")
        debugPrint("systemBlue = \(UIColor.systemBlue.hex16String)")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        UIView.appearance().tintColor = selectedColor
        UITabBar.appearance().tintColor = selectedColor
        AppLocalManager.shared.appColorHex = selectedColor.hex16String
                
        windowScene.windows.forEach { window in
            window.tintColor = selectedColor
            window.tintAdjustmentMode = .automatic
            window.tintColorDidChange()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(kAppThemeColorChangedKey), object: selectedColor)
    }
    
    // MARK: 🌹 GET && SET 🌹
    var item: UserCellItemType? {
        didSet {
            guard let item = self.item else { return }
            
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.image = item.cellImage()
            cellConfig.text = item.titleStr()
            cellConfig.imageProperties.maximumSize = kaka_IsMacOS() ? CGSizeMake(22.ckValue(), 22.ckValue()) : CGSizeMake(25.ckValue(), 25.ckValue())
            cellConfig.textProperties.color = UIColor.label
            cellConfig.imageProperties.tintColor = appMainColor
            if kaka_IsMacOS() {
                cellConfig.textProperties.font = UIFontLight(15.ckValue())
            }
            
            if item == .appearance || item == .themeColor || item == .autofill {
                if item == .appearance {
                    self.accessoryView = kaka_IsMacOS() ? nil : self.appearanceView()
                }
                
                if item == .themeColor {
                    self.accessoryView = self.colorWellView()
                }
                
                if item == .autofill {
                    ASCredentialIdentityStore.shared.getState { storeStatus in
                        DispatchQueue.main.async {
                            self.accessoryView = self.autofillView(storeStatus.isEnabled)
                        }
                    }
                }
                
            }else{
                self.accessoryView = nil
                self.accessoryView = .none
            }
            
            cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
            cellConfig.imageToTextPadding = 15
            self.contentConfiguration = cellConfig
        }
    }
    
    func autofillView(_ isAutoFill: Bool) -> UIImageView {
        let image = isAutoFill ? Reasource.systemNamed("checkmark.seal.fill", color: appMainColor) : Reasource.systemNamed("exclamationmark.triangle.fill", color: UIColor.red)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.size = CGSizeMake(25.ckValue(), 25.ckValue())
        return view
    }
    
    func colorWellView() -> UIColorWell {
        let view = UIColorWell(frame: CGRectMake(0, 0, 28.ckValue(), 28.ckValue()))
        view.backgroundColor = .clear
        view.supportsAlpha = false
        view.addTarget(self, action: #selector(colorWellValueChanged(_:)), for: .valueChanged)
        return view
    }
    
    func appearanceView() -> UIView {
        let title = AppLocalManager.shared.appearanceStyle.formatStr()
        let font = UIFontLight(11.ckValue())
        
        let view = kakaMenuView(frame: CGRectMake(0, 0, title.width(font) + 20.ckValue(), 50.ckValue()))
        view.menu = self.appearanceMenu()
        view.color = UIColor.secondaryLabel
        view.timeLabel.text = title
        view.contentHorizontalAlignment = .trailing
        view.showsMenuAsPrimaryAction = true
        return view
    }
    
    func appearanceMenu() -> UIMenu {
        let menu = UIMenu(title: UserCellItemType.appearance.titleStr() ?? "", children: [
            UIAction(title: AppearanceStyle.auto.formatStr(), handler: { _ in
                AppLocalManager.shared.appearanceStyle = .auto
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
            }),
            UIAction(title: AppearanceStyle.light.formatStr(), handler: { _ in
                AppLocalManager.shared.appearanceStyle = .light
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
            }),
            UIAction(title: AppearanceStyle.dark.formatStr(), handler: { _ in
                AppLocalManager.shared.appearanceStyle = .dark
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
            })
        ])
        return menu
    }
    
}

