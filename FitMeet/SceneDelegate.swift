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

