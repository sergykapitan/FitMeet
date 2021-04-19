//
//  MainTabBarViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let feed = HomeVC()
        feed.videos = Video.allVideos()
        viewControllers = [
            generateViewController(rootViewController: feed, image: #imageLiteral(resourceName: "Home") , title: "Home"),
            generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Profile"), title: "Search"),
            generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Stream") , title: "Stream"),
            generateViewController(rootViewController: StreamingVC(), image: #imageLiteral(resourceName: "Category"), title: "Category"),
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
