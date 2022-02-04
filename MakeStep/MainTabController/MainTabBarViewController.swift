//
//  MainTabBarViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import SwiftUI

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var profile: UIViewController?
    var streamView : UIViewController?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(hexString: "#3B58A4")
      //  navigationVC.tabBarItem.image?.withTintColor(UIColor(hexString: "#3B58A4"))
        self.tabBar.barTintColor = .white

       
        
        self.delegate = self
        
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
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
           

        }
        if #available(iOS 15.0, *) {
               let appearance2 = UITabBarAppearance()
               appearance2.configureWithOpaqueBackground()
               appearance2.backgroundColor = .white //or whatever your color is
               
               tabBar.scrollEdgeAppearance = appearance2
               tabBar.standardAppearance = appearance2
           }
       
    }
    
    private func generateViewController(rootViewController: UIViewController,image: UIImage,title: String) -> UIViewController {
  
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.backgroundColor = .white
        if navigationVC == NewStartStream() {
            navigationVC.modalPresentationStyle = .formSheet
            navigationVC.preferredContentSize = .init(width: 500, height: 800)
        }
        return navigationVC
    }

}
