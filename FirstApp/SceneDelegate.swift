//
//  SceneDelegate.swift
//  PassLock
//1
//  Created by Melo Dreek on 2023/5/5.
//

import KakaFoundation
import AppGroupKit
import SafariServices

let mainWindowSize: CGSize = CGSize(width: 600, height: 680)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    lazy var maskView: AppLockScreenView = {
        let view = AppLockScreenView()
        view.frame = (self.window ?? appKeyWindow)?.bounds ?? .zero
        return view
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if targetEnvironment(macCatalyst)
        windowScene.sizeRestrictions?.minimumSize = mainWindowSize
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .visible
            titlebar.toolbar = nil
            titlebar.autoHidesToolbarInFullScreen = true
            titlebar.toolbarStyle = .automatic
            titlebar.separatorStyle = .automatic
        }
        #endif
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = UIColor.systemBackground
        
        if AppLocalManager.shared.isShowedWelcome {
            let homeVC = kaka_IsiPhone() ? HomeTabbarViewController() : HomeSplitViewController(style: .doubleColumn)
            self.window?.rootViewController = homeVC
        }else{
            let welcomeVC = WelcomeFirsterViewController()
            self.window?.rootViewController = welcomeVC
        }
        
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        debugPrint("### sceneDidDisconnect ###")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if ScreenLockManager.shared.getScreenPassCode().isBackgroundMask {
            self.maskView.removeFromSuperview()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        
        
        if ScreenLockManager.shared.getScreenPassCode().isBackgroundMask {
            self.window?.addSubview(self.maskView)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        debugPrint("### sceneDidEnterBackground ###")
    }


}

