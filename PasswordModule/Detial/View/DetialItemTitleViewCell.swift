//
//  DetialItemTitleViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/1/10.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class DetialItemTitleViewCell: UITableViewCell {
    
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
        contentView.addSubview(coverImgView)
        contentView.addSubview(titleLabel)
    }
    
    private func preSetupContains() {
        
        coverImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(coverImgView.size)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImgView.snp.bottom).offset(15.ckValue())
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(titleLabel.font.lineHeight)
            make.bottom.equalToSuperview().inset(10.ckValue())
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    // MARK: 🌹 GET && SET 🌹
    var model: PrivateBaseItemModel? {
        didSet {
            coverImgView.image = model?.storageType.systemIconImage()
            titleLabel.text = model?.customTitle
        }
    }
    
    // MARK: 🌹 Lazy init 🌹
    
    lazy var coverImgView: UIImageView = {
        let view = UIImageView(frame: CGRectMake(0, 0, 80.ckValue(), 80.ckValue()))
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.ckValue()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = UIFontBold(18.ckValue())
        view.textColor = UIColor.label
        view.textAlignment = .center
        return view
    }()
    
}
