//
//  SuperViewController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/2.
//

import KakaUIKit
import KakaFoundation
import AppGroupKit

var kStatusBarHeight: CGFloat {
    get {
        let height = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 47
        return height == 0 ? 47 : height
    }
}


var app_navHeight: CGFloat {
    get {
        switch kaka_osType() {
        case .iOS: return 44 + kStatusBarHeight
        case .iPadOS: return 44.ckValue() + kStatusBarHeight
        case .macOS: return 50
        }
    }
}

public class SuperViewController: UIViewController {
    
    deinit {
        debugPrint("### \(self.className()) ###")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground

        self.preSetupSubViews()
        self.viewDidLayoutSubviews()
        self.preSetupHandleBuness()
    }
      
    public func preSetupSubViews() {
        view.addSubview(contentView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        contentView.frame = self.view.bounds
    }
    
    public func preSetupHandleBuness() {
        
    }
    
    @objc func appearanceChanged() {
        let overrideUserInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        
        if let navVC = self.navigationController {
            navVC.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppLocalManager.shared.appearanceStyle.statusBarStyle()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        contentView.frame = self.view.bounds
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    public lazy var contentView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .clear
        return view
    }()
      
}
