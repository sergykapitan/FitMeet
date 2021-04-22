//
//  MainTabBarViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import SwiftUI

class MainTabBarViewController: UITabBarController {
   let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    override func viewDidLoad() {
        super.viewDidLoad()
        print(token)
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
        var homeNew = NoSpaceList()
        homeNew.videos = Video.allVideos()
        let hostNewVC = UIHostingController(rootView: homeNew)
        hostNewVC.tabBarItem.image = #imageLiteral(resourceName: "Search")
        hostNewVC.tabBarItem.title = "Search"
        viewControllers = [
            hostVC,hostNewVC,
           // generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Profile"), title: "Search"),
            generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Stream") , title: "Stream"),
            categoryVC,
            generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Profile") , title: "Profile")
        ]
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
