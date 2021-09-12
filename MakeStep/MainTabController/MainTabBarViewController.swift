//
//  MainTabBarViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import SwiftUI

class MainTabBarViewController: UITabBarController {
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(hexString: "#3B58A4")
      //  navigationVC.tabBarItem.image?.withTintColor(UIColor(hexString: "#3B58A4"))
        self.tabBar.barTintColor = .white
        
        
        //HomeUI
        var home = HomeUI()
        home.videos = Video.allVideos()
        let hostVC = UIHostingController(rootView: home)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
        hostVC.tabBarItem.title = ""
    
        var profile: UIViewController?
        var streamView : UIViewController?
        
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
        
        if token != nil {
            profile = ProfileVC()
            streamView = NewStartStream()
        } else {
            profile = StartScreen()
            streamView = NotTokenView()
          }

        viewControllers = [
            generateViewController(rootViewController: HomeVC(), image: #imageLiteral(resourceName: "home(1) 31"), title: ""),
            generateViewController(rootViewController: SearchVC(), image: #imageLiteral(resourceName: "search 51"), title: ""),
            generateViewController(rootViewController: streamView ?? NotTokenView() , image: #imageLiteral(resourceName: "Act1") , title: ""),
            generateViewController(rootViewController: CategoryVC(), image: #imageLiteral(resourceName: "Group 25931"), title: ""),
            generateViewController(rootViewController: profile ?? StartScreen(), image: #imageLiteral(resourceName: "user(2) 11") , title: "")
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func generateViewController(rootViewController: UIViewController,image: UIImage,title: String) ->UIViewController {
  
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.backgroundColor = .white
        return navigationVC
    }

}
