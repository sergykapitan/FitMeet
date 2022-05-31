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
    var pathKey: String?
    var pathId: String?
    
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
        sleep(1)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let urlinfo = userActivity.webpageURL{
            
            window.rootViewController = MainTabBarViewController()
            self.window = window
            window.makeKeyAndVisible()
            
            let reminderDetailsVC = PlayerViewVC()
            let path = urlinfo.pathComponents
            if path.count == 4 {
                pathKey = path[3]
                pathId = path[2]
                reminderDetailsVC.isPrivate = true
            } else {
                pathKey = ""
                pathId = urlinfo.lastPathComponent
                reminderDetailsVC.isPrivate = false
            }
            if let tableVC = window.rootViewController as? MainTabBarViewController {
                  
                   reminderDetailsVC.modalPresentationStyle = .fullScreen
                   reminderDetailsVC.broadId = pathId
                   reminderDetailsVC.privateKey = pathKey
                   tableVC.present(reminderDetailsVC, animated: true)
            }
        } else {
            openRootViewController(viewController: MainTabBarViewController(), windowScene: windowScene)
        }
    }

    func openRootViewController(viewController: UIViewController,windowScene: UIWindowScene) {
        self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    func openMain() {
        let tabBC =  MainTabBarViewController()
        tabBC.boolStream = false
        NotificationCenter.default.post(Notification(name: .refreshAllTabs))
        tabBC.selectedIndex = 2
        
    }
}

extension SceneDelegate {
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let urlinfo = userActivity.webpageURL{
            
            let reminderDetailsVC = PlayerViewVC()
            let path = urlinfo.pathComponents
            if path.count == 4 {
                pathKey = path[3]
                pathId = path[2]
                reminderDetailsVC.isPrivate = true
            } else {
                pathKey = ""
                pathId = urlinfo.lastPathComponent
                reminderDetailsVC.isPrivate = false
            }
            if let tableVC = self.window?.rootViewController as? MainTabBarViewController {
                  
                   reminderDetailsVC.modalPresentationStyle = .fullScreen
                   reminderDetailsVC.broadId = pathId
                   reminderDetailsVC.privateKey = pathKey
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
