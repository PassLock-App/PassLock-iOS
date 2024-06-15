//
//  SelectAvatarViewCell.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/4.
//

import KakaFoundation

class SelectAvatarViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.backgroundColor = UIColor.clear
        contentView.addSubview(avatarView)
        
    }
    
    private func preSetupContains() {
        avatarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}
