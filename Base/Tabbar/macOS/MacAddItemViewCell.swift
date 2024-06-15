//
//  MacAddItemView.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit


class MacAddItemViewCell: UITableViewCell {
    
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
        self.addSubview(addBackView)
        self.addSubview(addIconView)
    }
    
    private func preSetupContains() {
        addBackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(addBackView.layer.cornerRadius * 2)
        }
        
        addIconView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(addBackView)
            make.size.equalTo(addBackView).multipliedBy(0.38)
        }
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    // MARK:  GET && SET
    
    // MARK:  Lazy Init
    lazy var addBackView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 60.ckValue(), 60.ckValue()))
        view.backgroundColor = appMainColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30.ckValue()
        return view
    }()
    
    lazy var addIconView: UIImageView = {
        let view = UIImageView(image: Reasource.systemNamed("plus", color: .white))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
