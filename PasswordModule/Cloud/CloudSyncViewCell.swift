//
//  CloudSyncViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import AppGroupKit

class CloudSyncViewCell: UITableViewCell {
    
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
        self.selectionStyle = .none
        
    }
    
    private func preSetupContains() {
        
    }
    
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .default
    }
    
    @objc func switchViewChanged(_ sender: UISwitch) {
        
        guard var vModel = self.syncModel, let item = self.item else { return }
        
        if item == .compressImage {
            vModel.isCompressImage = !vModel.isCompressImage
        }
        
        if item == .autoDeleteTips {
            vModel.isAutoDeleteAssets = !vModel.isAutoDeleteAssets
        }
        
        if item == .autoSyncCloud {
            vModel.isAutoSyncCloud = !vModel.isAutoSyncCloud
        }
        
        CloudSyncManager.shared.update(vModel)
        
        self.onCallBack?(vModel, item)
    }
    
    func update(cellType: CloudCellItemType, config: CloudSyncModel) {
        self.item = cellType
        self.syncModel = config
        
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.text = cellType.titleStr()
        cellConfig.textProperties.color = UIColor.label
        
        cellConfig.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        cellConfig.imageToTextPadding = 15
        
        if cellType == .compressImage {
            self.accessoryView = self.switchView
            self.switchView.isOn = config.isCompressImage
            self.switchView.isEnabled = true
        }
        
        if cellType == .autoDeleteTips {
            self.accessoryView = self.switchView
            self.switchView.isOn = config.isAutoDeleteAssets
            self.switchView.isEnabled = true
        }
        
        if cellType == .autoSyncCloud {
            
        }
        
        self.contentConfiguration = cellConfig
    }
    
    // MARK:  GET && SET
    
    var onCallBack: ((CloudSyncModel, CloudCellItemType)->Void)?

    public var syncModel: CloudSyncModel?
    
    private var item: CloudCellItemType?
    
    // MARK:  Lazy Init
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = appMainColor
        view.addTarget(self, action: #selector(switchViewChanged(_:)), for: .valueChanged)
        return view
    }()
}

