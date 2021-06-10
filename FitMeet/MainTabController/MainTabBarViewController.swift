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
        self.tabBar.tintColor = UIColor(hexString: "#0099AE")
        self.tabBar.barTintColor = .white
        
        
        //HomeUI
        var home = HomeUI()
        home.videos = Video.allVideos()
        let hostVC = UIHostingController(rootView: home)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
        hostVC.tabBarItem.title = ""
        //CategoryUI
//        let category = CategoryUI()
//        let categoryVC = UIHostingController(rootView: category)
//        categoryVC.tabBarItem.image = #imageLiteral(resourceName: "Category")
//        categoryVC.tabBarItem.title = ""
        //newList
//        let listChannel = ListChannell()
//        let channelVC = UIHostingController(rootView: listChannel)
//        channelVC.tabBarItem.image = #imageLiteral(resourceName: "Stream")
//        channelVC.tabBarItem.title = ""
            
        var profile: UIViewController?
        var streamView : UIViewController?
        
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
        if token != nil {
            profile = ProfileVC()
            streamView = StreamingVC()
        } else {
            profile = AuthViewController()
            streamView = NotTokenView()
          }

        viewControllers = [
           // hostVC,
            generateViewController(rootViewController: HomeVC(), image: #imageLiteral(resourceName: "Home"), title: ""),
            generateViewController(rootViewController: SearchVC(), image: #imageLiteral(resourceName: "Profile"), title: ""),
            generateViewController(rootViewController: streamView ?? SearchVC(), image: #imageLiteral(resourceName: "Stream") , title: ""),
            generateViewController(rootViewController: CategoryVC(), image: #imageLiteral(resourceName: "Category"), title: ""),
            generateViewController(rootViewController: profile ?? AuthViewController(), image: #imageLiteral(resourceName: "Profile") , title: "")
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
