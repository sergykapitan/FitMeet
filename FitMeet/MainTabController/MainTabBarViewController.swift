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
        
        //HomeUI
        var home = HomeUI()
        home.videos = Video.allVideos()
        let hostVC = UIHostingController(rootView: home)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
        hostVC.tabBarItem.title = "Home"
        //CategoryUI
        let category = CategoryUI()
        let categoryVC = UIHostingController(rootView: category)
        categoryVC.tabBarItem.image = #imageLiteral(resourceName: "Category")
        categoryVC.tabBarItem.title = "Category"
        //newList
        let listChannel = ListChannell()
        let channelVC = UIHostingController(rootView: listChannel)
        channelVC.tabBarItem.image = #imageLiteral(resourceName: "Stream")
        channelVC.tabBarItem.title = "Stream"
        
        
//        var searchVC = SearchVC()
//        let hostNewVC = UIHostingController(rootView: searchVC)
//        hostNewVC.tabBarItem.image = #imageLiteral(resourceName: "Search")
//        hostNewVC.tabBarItem.title = "Search"
        //
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PopUpLive") as! LiveViewController
//        
        var profile: UIViewController?
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
        print(token)
        if token != nil {
            profile = ProfileVC()
        } else {
            profile = AuthViewController()
          }

        
        
        viewControllers = [
            hostVC,
            generateViewController(rootViewController: SearchVC(), image: #imageLiteral(resourceName: "Profile"), title: "Search"),
            channelVC,
           // generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Stream") , title: "Stream"),
            categoryVC,
            generateViewController(rootViewController: profile ?? AuthViewController(), image: #imageLiteral(resourceName: "Profile") , title: "Profile")                        
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
