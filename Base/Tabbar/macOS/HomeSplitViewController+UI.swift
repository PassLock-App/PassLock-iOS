//
//  HomeSplitViewController+UI.swift
//  PassLock
//
//  Created by Melo on 2024/6/7.
//

import KakaFoundation
import AppGroupKit

extension HomeSplitViewController {
    @objc func appearanceChanged() {
        self.overrideUserInterfaceStyle = AppLocalManager.shared.appearanceStyle.userInterfaceStyle()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func appModeStyleChanged(_ noti: Notification) {
        guard let newColor = noti.object as? UIColor else { return }
        self.view.tintColor = newColor
    }
    
}
