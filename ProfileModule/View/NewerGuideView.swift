//
//  NewerGuideView.swift
//  PassLock
//
//  Created by Melo on 2023/12/23.
//

import KakaUIKit
import AppGroupKit

class NewerGuideView: UIView {
    
    init(frame: CGRect, maskFrame: CGRect, maskCorner: CGFloat) {
        super.init(frame: frame)
        self.maskFrame = maskFrame
        self.maskCorner = maskCorner
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        let path = UIBezierPath(rect: self.bounds)
        path.append(UIBezierPath(roundedRect: self.maskFrame, cornerRadius: self.maskCorner).reversing())
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
        
        let clickView = UIControl(frame: self.maskFrame)
        clickView.addTarget(self, action: #selector(clickViewAction), for: .touchUpInside)
        self.addSubview(clickView)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) { [weak self] () in
            guard let wSelf = self else { return }
            wSelf.fingerView.frame = CGRectMake(wSelf.width / 2, wSelf.maskFrame.origin.y + wSelf.maskFrame.height / 2, 59.ckValue(), 50.ckValue())
            wSelf.superview?.addSubview(wSelf.fingerView)
            wSelf.fingerView.startAnimating()
        }
    }
    
    private func preSetupContains() {
        
    }
    
    private func preSetupHandleBuness() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @objc func clickViewAction() {
        self.fingerView.stopAnimating()
        self.fingerView.removeFromSuperview()
        self.removeFromSuperview()
        self.onClickCallBack?()
    }
    
    // MARK: 🌹 GET && SET 🌹
    var maskFrame: CGRect!
    
    var maskCorner: CGFloat = 0
    
    var onClickCallBack: (()->Void)?
    
    
    // MARK: 🌹 Lazy Init 🌹
    lazy var fingerView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.animationImages = [Reasource.named("finger_1").flippedImage(), Reasource.named("finger_2").flippedImage()]
        view.animationDuration = 0.35
        view.animationRepeatCount = 0
        return view
    }()
    
}
