//
//  PasswordBasicViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/31.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import SDWebImage

class PasswordBasicViewCell: UITableViewCell {
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
        contentView.addSubview(modifyLabel)
    }
    
    private func preSetupContains() {
        coverImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(coverImgView.size)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(titleLabel.font.lineHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(coverImgView.snp.bottom).offset(15.ckValue())
        }
        
        modifyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(2.ckValue())
            make.height.greaterThanOrEqualTo(modifyLabel.font.lineHeight)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    // MARK:  GET && SET
    var model: PrivateBaseItemModel? {
        didSet {
            guard let model = model else { return }
            
            model.loadCoverImage(imageSize: coverImgView.size) { [weak self] newImage in
                self?.coverImgView.image = newImage
            }
            
            titleLabel.text = model.customTitle
            
            if let modifyDate = model.modifyDate?.rounded() {
                let date = Date(timeIntervalSince1970: modifyDate)
                modifyLabel.text = "Last modified time:".localStr() + date.dateString(ofStyle: .medium)
            }else{
                modifyLabel.text = "Last modified time:".localStr() + "N/A"
            }
        }
    }
    
    
    // MARK:  Lazy init 
    lazy var coverImgView: UIImageView = {
        let view = UIImageView(frame: CGRectMake(0, 0, 80.ckValue(), 80.ckValue()))
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.ckValue()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = UIFontBold(18.ckValue())
        view.textColor = UIColor.label
        view.textAlignment = .center
        return view
    }()
    
    lazy var modifyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.font = UIFontLight(14.ckValue())
        view.textColor = UIColor.secondaryLabel
        view.textAlignment = titleLabel.textAlignment
        return view
    }()
    
}
