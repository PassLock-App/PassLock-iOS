//
//  ScanPlatViewController.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit

class ScanPlatViewController: SuperViewController {
    override func preSetupSubViews() {
        super.preSetupSubViews()
        
        self.title = MacTabbarCellItemType.downloadIOS.formatStr()
        
        contentView.addSubview(qrcodeImgView)
        contentView.addSubview(cameraLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        qrcodeImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(300.ckValue())
        }
        
        cameraLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
    }
    
    override func preSetupHandleBuness() {
        super.preSetupHandleBuness()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonClick))
    }
    
    @objc func closeButtonClick() {
        (self.navigationController ?? self).dismiss(animated: true)
    }
    
    // MARK:  GET && SET
    
    
    // MARK:  Lazy Init
    
    lazy var qrcodeImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "app_qrcode"))
        return view
    }()
    
    lazy var cameraLabel: UILabel = {
        let view = UILabel()
        view.text = "We recommend using Apple's native camera app for scanning".localStr()
        view.font = UIFontLight(12.ckValue())
        view.textColor = UIColor.secondaryLabel
        view.textAlignment = .center
        return view
    }()
}


