//
//  AddWebsiteTableCell.swift
//  PassLock
//
//  Created by Melo on 2024/6/2.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class AddWebsiteTableCell: UITableViewCell {
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
        self.selectionStyle = .default
                
        contentView.addSubview(leftImgView)
        contentView.addSubview(websiteLabel)
    }
    
    private func preSetupContains() {
        
        let leftSpace = 18.ckValue()
        
        leftImgView.snp.makeConstraints { make in
            make.leading.equalTo(leftSpace)
            make.centerY.equalToSuperview()
            make.size.equalTo(leftImgView.size)
        }
        
        websiteLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImgView.snp.trailing).offset(leftSpace)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK:  GET && SET
    weak var delegate: AddAccountPassDelegate?
    
    var model: PrivateBaseItemModel? {
        didSet {
            
            let isWebsite = (model?.passwordModel?.websiteModel?.host?.count ?? 0) > 1
            
            websiteLabel.text = model?.passwordModel?.websiteModel?.host ?? "URL(optional)".localStr()
            websiteLabel.font = isWebsite ? UIFontLight(16.ckValue()) : UIFontLight(12.ckValue())
            websiteLabel.textColor = isWebsite ? UIColor.label : UIColor.secondaryLabel
        }
    }
    
    // MARK:  Lazy Init
    lazy var leftImgView: UIImageView = {
        let view = UIImageView(image: AddItemType.website.leftIconImage())
        view.contentMode = .scaleAspectFit
        view.size = CGSize(width: 22.ckValue(), height: 22.ckValue())
        return view
    }()
    
    lazy var websiteLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        view.font = UIFontLight(16.ckValue())
        view.textColor = UIColor.label
        return view
    }()
    
}
