//
//  AddPrivateItemHeadView.swift
//  PassLock
//
//  Created by Melo on 2024/6/4.
//

import KakaFoundation
import AppGroupKit

class AddPrivateItemHeadView: UIView {
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
        self.addSubview(coverImgView)
    }
    
    private func preSetupContains() {
        
        coverImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10.ckValue())
            make.size.equalTo(coverImgView.size)
        }
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = .clear
        
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(gesClickAction))
        self.addGestureRecognizer(clickTap)
    }
    
    @objc func gesClickAction() {
        self.viewController?.view.endEditing(true)
    }
    
    // MARK:  GET && SET
    var model: PrivateBaseItemModel? {
        didSet {
            let imageSize = coverImgView.size
            
            let imgURL = URL(string: self.model?.passwordModel?.websiteModel?.imageUrlStr() ?? "")
            let placeImage = ((model?.firstString() ?? "#").image(withAttributes: [.font: UIFont.boldSystemFont(ofSize: imageSize.width * 0.6)], size: imageSize, backgroundColor: UIColor.rgb(123, 123, 129), textColor: UIColor.white))
            
            coverImgView.sd_setImage(with: imgURL, placeholderImage: placeImage)
        }
    }
    
    // MARK:  Lazy Init
    
    lazy var coverImgView: UIImageView = {
        let view = UIImageView(frame: CGRectMake(0, 0, 80.ckValue(), 80.ckValue()))
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.ckValue()
        return view
    }()
    
}
