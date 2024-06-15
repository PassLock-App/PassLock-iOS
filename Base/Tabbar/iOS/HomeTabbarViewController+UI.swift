//
//  HomeTabbarViewController+UI.swift
//  PassLock
//
//  Created by Melo on 2024/5/28.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import MBProgressHUD

extension HomeTabbarViewController {
    
    @objc func initSubController() {
        
        self.createChildController(childVC: PasswordViewController(.allItem), title: KakaTabbarItem.passwords.formatStr(), image: Reasource.systemNamed("key.icloud"), selImage: Reasource.systemNamed("key.icloud.fill"), tag: 0)
        
        self.createChildController(childVC: PassCreaterViewController(), title: KakaTabbarItem.creater.formatStr(), image: Reasource.systemNamed("ellipsis.rectangle"), selImage: Reasource.systemNamed("ellipsis.rectangle.fill"), tag: 1)
        
        let norImage = Reasource.systemNamed("quote.bubble").sfHorizontallyImage()
        let selImage = Reasource.systemNamed("quote.bubble.fill").sfHorizontallyImage()
        self.createChildController(childVC: TransparencyViewController(), title: KakaTabbarItem.developer.formatStr(), image: norImage, selImage: selImage, tag: 2)
        
        self.createChildController(childVC: ProfileViewController(), title: KakaTabbarItem.profile.formatStr(), image: Reasource.systemNamed("person.crop.circle"), selImage: Reasource.systemNamed("person.crop.circle.fill"), tag: 3)
        
        let tabbar = KakaTabbarView(frame: self.tabBar.bounds)
        tabbar.plusButton.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        self.setValue(tabbar, forKey: "tabBar")
        
        self.kakaTabbar = tabbar
        
        let locals = SandboxFileManager.shared.readPrivateItemModels(recordType: .defaultBook, itemType: .allItem)
        
        if locals.count <= 10 {
            self.selectedIndex = 2
        }else{
            self.selectedIndex = 0
        }
    }
    
    func createChildController(childVC: UIViewController, title: String, image: UIImage, selImage: UIImage, tag: Int) {
        childVC.tabBarItem.title = title
        childVC.tabBarItem.tag = tag
        
        childVC.tabBarItem.image = image.withRenderingMode(.automatic)
        var textAttres = [NSAttributedString.Key: Any]()
        textAttres[.font] = UIFont.systemFont(ofSize: 9.ckValue())
        textAttres[.foregroundColor] = UIColor.secondaryLabel
        
        childVC.tabBarItem.selectedImage = selImage.withRenderingMode(.automatic)
        var selectTextAttres = [NSAttributedString.Key: Any]()
        selectTextAttres[.font] = UIFont.systemFont(ofSize: 9.ckValue())
        selectTextAttres[.foregroundColor] = appMainColor
        
        childVC.tabBarItem.setTitleTextAttributes(textAttres, for: .normal)
        childVC.tabBarItem.setTitleTextAttributes(selectTextAttres, for: .selected)
        
        self.addChild(KakaNavigationController(rootViewController: childVC))
    }
    
    
    @objc func appearanceChanged() {
        self.overrideUserInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let newColor = noti.object as? UIColor else { return }
        self.tabBar.tintColor = newColor
        
        for subItem in (self.tabBar.items ?? []) {
            subItem.setTitleTextAttributes([.foregroundColor: appMainColor], for: .selected)
        }
    }
    
}

