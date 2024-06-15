//
//  AppLockScreenView.swift
//  SV
//
//  Created by Melo Dreek on 2023/2/10.
//

import KakaUIKit

class AppLockScreenView: UIView {
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
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.rgb(60, 66, 107)
        self.addSubview(screenImgView)
    }
    
    private func preSetupContains() {
        screenImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20.ckValue())
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(screenImgView.snp.width)
        }
    }
    
    private func preSetupHandleBuness() {
//        let clickTap = UITapGestureRecognizer()
//        clickTap.addActionBlock { [weak self] (_) in
//            self?.removeFromSuperview()
//        }
//        self.addGestureRecognizer(clickTap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    lazy var screenImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "app_langh")
        return view
    }()

}
