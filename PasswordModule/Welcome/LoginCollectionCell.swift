//
//  LoginCollectionCell.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation

class LoginCollectionCell: UICollectionViewCell {
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
        contentView.addSubview(coverImgView)
    }
    
    private func preSetupContains() {
        coverImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if kaka_IsMacOS() {
                make.top.equalToSuperview().offset(70.ckValue())
                make.size.equalTo(380)
            }else{
                make.bottom.equalTo(contentView.snp.centerY)
                make.width.equalToSuperview().multipliedBy(kaka_IsiPad() ? 0.5 : 0.75)
                make.height.equalTo(coverImgView.snp.width)
            }
        }
        
    }
    
    
    private func preSetupHandleBuness() {

    }
    
    // MARK:  GET && SET
    var model: WelcomeInfoModel? {
        didSet {
            guard let vModel = self.model else { return }
            
            self.backgroundColor = vModel.backColor
            coverImgView.image = Reasource.named(vModel.iconName)
        }
    }
    
    // MARK:  Lazy init
    lazy var coverImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
}

