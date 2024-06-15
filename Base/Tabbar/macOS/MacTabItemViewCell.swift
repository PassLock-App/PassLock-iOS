//
//  MacTabItemViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit

class MacTabItemViewCell: UITableViewCell {
    
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
        self.addSubview(selectView)
        
    }
    
    private func preSetupContains() {
        selectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        
        self.accessoryType = kaka_IsiPad() ? .disclosureIndicator : .none
    }
    
    // MARK:  GET && SET
    var itemType: MacTabbarCellItemType? {
        didSet {
            guard let itemType = itemType else { return }
            var cellConfig = UIListContentConfiguration.sidebarCell()
            cellConfig.text = itemType.formatStr()
            cellConfig.textProperties.font = UIFontLight(13.ckValue())
            cellConfig.textProperties.color = UIColor.label
            cellConfig.imageProperties.maximumSize = CGSize(width: 24.ckValue(), height: 24.ckValue())
            cellConfig.image = itemType.iconImage()
            cellConfig.secondaryTextProperties.color = UIColor.secondaryLabel
            if kaka_IsMacOS() {
                cellConfig.textProperties.font = UIFontLight(14.ckValue())
            }
            
            self.contentConfiguration = cellConfig
        }
    }
    
    var isSelect: Bool = true {
        didSet {
            self.selectView.isHidden = !isSelect
        }
    }
    
    // MARK:  Lazy Init
    lazy var selectView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = kaka_IsMacOS() ? 6.ckValue() : 0
        view.backgroundColor = kaka_IsMacOS() ? UIColor.systemFill : UIColor.placeholderText
        return view
    }()
    
}

