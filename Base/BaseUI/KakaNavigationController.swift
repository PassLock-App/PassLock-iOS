//
//  KakaNavigationController.swift
//   PassLock
//
//  Created by Melo Dreek on 2023/2/2.
//

import KakaUIKit
import AppGroupKit
import KakaFoundation

class KakaNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preSetupSubViews()
        self.preInitSubFrames()
        self.preHanleBuness()
        
    }
    
    private func preSetupSubViews() {
        self.delegate = self

        let barAppearance = UINavigationBarAppearance(idiom: UIDevice.current.userInterfaceIdiom)
        barAppearance.configureWithTransparentBackground()
        self.navigationBar.scrollEdgeAppearance = barAppearance
    }
    
    private func preInitSubFrames() {
        debugPrint("UINavigationBar.appearance().size = \(self.navigationBar.size)")
    }
    
    private func preHanleBuness() {
        NotificationCenter.default.addObserver(self, selector: #selector(appModeStyleChanged(_:)), name: NSNotification.Name(rawValue: kAppThemeColorChangedKey), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceChanged), name: NSNotification.Name(rawValue: kAppearanceChangedKey), object: nil)
        
        self.appearanceChanged()
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let newColor = noti.object as? UIColor else { return }
        self.navigationBar.tintColor = newColor
    }
    
    @objc func appearanceChanged() {
        let userInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.overrideUserInterfaceStyle = userInterfaceStyle
        self.setNeedsStatusBarAppearanceUpdate()
    }
}


extension KakaNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers.first {
            self.interactivePopGestureRecognizer?.delegate = self.delegate! as? UIGestureRecognizerDelegate
        } else {
            self.interactivePopGestureRecognizer?.delegate = nil
        }
    }
        
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }

}
