//
//  KakaTabbarView.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit

class KakaTabbarView: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(self.plusView)
        self.plusView.addSubview(plusButton)
        self.plusView.addSubview(plusIconView)
        
        plusButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.80)
            make.width.equalTo(plusView.snp.height).multipliedBy(1.1)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(3.ckValue())
        }
        
        plusIconView.snp.makeConstraints { make in
            make.center.equalTo(plusButton)
            make.size.equalTo(20.ckValue())
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarButtonW: CGFloat = self.frame.width / 5
        var tabBarButtonIndex: CGFloat = 0
        
        self.plusView.frame = CGRectMake(tabBarButtonW * 2, 0, tabBarButtonW, self.frame.height)
        
        for child in self.subviews {
            if let childClass: AnyClass = NSClassFromString("UITabBarButton") {
                if child.isKind(of: childClass) {
                    child.frame.origin.x = tabBarButtonIndex * tabBarButtonW
                    
                    child.frame.size.width = tabBarButtonW
                    
                    self.plusView.frame.size.height = child.frame.size.height
                    
                    tabBarButtonIndex += 1
                    
                    if tabBarButtonIndex == 2 {
                        tabBarButtonIndex += 1
                    }
                }
            }
        }

    }
    
    private func preSetupHandleBuness() {
        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
        
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let newColor = noti.object as? UIColor else { return }
        self.plusButton.backgroundColor = newColor
    }
    
    // MARK:  GET && SET
    func startArrowAnimation() {
        
    }
    
    func stopArrowAnimation() {
        
    }
    
    // MARK:  Lazy Init
    lazy var plusView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var plusButton: UIControl = {
        let view = UIControl()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4.ckValue()
        view.backgroundColor = appMainColor
        return view
    }()
    
    lazy var plusIconView: UIImageView = {
        let view = UIImageView()
        view.image = Reasource.systemNamed("plus", color: .white)
        view.backgroundColor = .clear
        return view
    }()
    
}
