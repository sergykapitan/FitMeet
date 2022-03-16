//
//  SceneDelegate.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    lazy var deeplinkCoordinator : DeeplinkCoordinatorProtocol = {
           return DeeplinkCoordinator(handlers: [
               AccountDeeplinkHandler(rootViewController: self.rootViewController),
               VideoDeeplinkHandler(rootViewController: self.rootViewController)
           ])
       }()
    var rootViewController: UIViewController? {
            return window?.rootViewController
        }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
           openRootViewController(viewController: MainTabBarViewController(), windowScene: windowScene)
    }

    func openRootViewController(viewController: UIViewController,windowScene: UIWindowScene) {
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let urlinfo = userActivity.webpageURL{
            let pathId = urlinfo.lastPathComponent
            if let tableVC = self.window?.rootViewController as? MainTabBarViewController {
                   let reminderDetailsVC = PlayerViewVC()
                   reminderDetailsVC.modalPresentationStyle = .fullScreen
                   reminderDetailsVC.isPrivate = true
                   reminderDetailsVC.broadId = pathId
                   tableVC.present(reminderDetailsVC, animated: true)
                 }
          }
    }
    
  
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else {
            return
        }
        print(firstUrl.absoluteString)
        deeplinkCoordinator.handleURL(firstUrl)
    }
}
