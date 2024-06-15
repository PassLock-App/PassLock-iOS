//
//  SafetyTableViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/3/16.
//

import KakaFoundation
import AppGroupKit

class SafetyTableViewCell: UITableViewCell {
    
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
        
    }
    
    
    
    @objc func switchViewChanged(_ sender: UISwitch) {
        guard var vModel = self.screenModel, let item = self.item else { return }
        
        if item == .passwordSwitch {
            vModel.isPasswordEnble = sender.isOn
            vModel.password = nil
        }
        
        if item == .enableFaceID {
            vModel.isFaceIdEnble = sender.isOn
        }
        
        if item == .backgroundMask {
            vModel.isBackgroundMask = sender.isOn
        }
        
        ScreenLockManager.shared.saveScreenPassCode(vModel)
        
        self.onCallBack?(vModel, item)
    }
    
    // MARK: 🌹 GET && SET 🌹
    var onCallBack: ((ScreenLockModel, SafetyCellItemType)->Void)?
    
    private var screenModel: ScreenLockModel?
    
    private var item: SafetyCellItemType?
    
    var option = UIMenuElement.State.mixed
    
    func update(item: SafetyCellItemType, screenModel: ScreenLockModel) {
        self.screenModel = screenModel
        self.item = item
        
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.text = item.titleStr()
        cellConfig.textProperties.color = UIColor.label
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        if item == .passwordSwitch {
            self.accessoryView = switchView
            self.selectionStyle = .default
            switchView.isOn = screenModel.isPasswordEnble
            self.isUserInteractionEnabled = true
        }
        
        if item == .passwordModify {
            self.accessoryView = nil
            self.selectionStyle = screenModel.isPasswordEnble ? .default : .none
            cellConfig.textProperties.color = screenModel.isPasswordEnble ? appMainColor : appMainColor.withAlphaComponent(0.5)
            self.isUserInteractionEnabled = screenModel.isPasswordEnble
        }
        
        if item == .enableFaceID {
            // Face ID
            self.accessoryView = switchView
            self.selectionStyle = .default
            self.selectionStyle = screenModel.isPasswordEnble ? .default : .none
            switchView.isOn = screenModel.isFaceIdEnble
            switchView.isEnabled = screenModel.isPasswordEnble
            cellConfig.textProperties.color = screenModel.isPasswordEnble ? UIColor.label : UIColor.label.withAlphaComponent(0.5)
            self.isUserInteractionEnabled = screenModel.isPasswordEnble
        }
        
        if item == .backgroundTime {
            cellConfig.textProperties.color = screenModel.isPasswordEnble ? UIColor.label : UIColor.label.withAlphaComponent(0.5)
            self.isUserInteractionEnabled = screenModel.isPasswordEnble
            
            self.accessoryView = self.timeAccessView
            timeAccessView.color = screenModel.isPasswordEnble ? appMainColor : appMainColor.withAlphaComponent(0.5)
            timeAccessView.timeLabel.text = screenModel.timeSpace.formatStr()
            
        }
        
        if item == .backgroundMask {
            self.accessoryView = switchView
            self.selectionStyle = .default
            switchView.isOn = screenModel.isBackgroundMask
            self.isUserInteractionEnabled = true
        }
        
        self.contentConfiguration = cellConfig
    }
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = appMainColor
        view.addTarget(self, action: #selector(switchViewChanged(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var menu: UIMenu = {
        let menu = UIMenu(title: "Select Time Interval".localStr(), children: [
            UIAction(title: LockTimeSpace.immediate.formatStr(), handler: { [weak self] _ in
                guard let wSelf = self, var vModel = wSelf.screenModel else { return }
                vModel.timeSpace = .immediate
                ScreenLockManager.shared.saveScreenPassCode(vModel)
                wSelf.onCallBack?(vModel, wSelf.item!)
            }),
            UIAction(title: LockTimeSpace.five.formatStr(), handler: { [weak self] _ in
                guard let wSelf = self, var vModel = wSelf.screenModel else { return }
                vModel.timeSpace = .five
                ScreenLockManager.shared.saveScreenPassCode(vModel)
                wSelf.onCallBack?(vModel, wSelf.item!)
            }),
            UIAction(title: LockTimeSpace.ten.formatStr(), handler: { [weak self] _ in
                guard let wSelf = self, var vModel = wSelf.screenModel else { return }
                vModel.timeSpace = .ten
                ScreenLockManager.shared.saveScreenPassCode(vModel)
                wSelf.onCallBack?(vModel, wSelf.item!)
            }),
            UIAction(title: LockTimeSpace.fifteen.formatStr(), handler: {[weak self] _ in
                guard let wSelf = self, var vModel = wSelf.screenModel else { return }
                vModel.timeSpace = .fifteen
                ScreenLockManager.shared.saveScreenPassCode(vModel)
                wSelf.onCallBack?(vModel, wSelf.item!)
            })
        ])
        return menu
    }()
    
    lazy var timeAccessView: kakaMenuView = {
        let title = AppLocalManager.shared.appearanceStyle.formatStr()
        let font = UIFontLight(11.ckValue())
        
        let view = kakaMenuView(frame: CGRectMake(0, 0, title.width(font) + 20.ckValue(), 50.ckValue()))
        view.menu = self.menu
        view.color = UIColor.secondaryLabel
        view.timeLabel.text = title
        view.contentHorizontalAlignment = .trailing
        view.showsMenuAsPrimaryAction = true
        return view
    }()
    
}
