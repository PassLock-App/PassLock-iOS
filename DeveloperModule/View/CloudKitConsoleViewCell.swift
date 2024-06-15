//
//  CloudKitConsoleViewCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/29.
//

import KakaFoundation

class CloudKitConsoleViewCell: UITableViewCell {
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
        contentView.addSubview(openImgView)
    }
    
    private func preSetupContains() {
        let cellImage = CloudKitConsoleItemType.console1.cellImage()
        let imgVaule = cellImage.size.height / cellImage.size.width
        
        openImgView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(openImgView.snp.width).multipliedBy(imgVaule)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK:  GET && SET
    var model: CloudKitConsoleItemType? {
        didSet {
            guard let model = self.model else { return }
            
            openImgView.image = model.cellImage()
        }
    }
    
    
    // MARK:  Lazy Init
    lazy var openImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
