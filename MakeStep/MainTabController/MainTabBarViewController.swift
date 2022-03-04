//
//  MainTabBarViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import SwiftUI

extension Notification.Name {
    static let refreshAllTabs = Notification.Name("RefreshAllTabs")
}


class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var profile: UIViewController?
    var streamView : UIViewController?
    var boolStream: Bool = true
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .blueColor// UIColor(hexString: "#3B58A4")
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
    deinit {
           NotificationCenter.default.removeObserver(self)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .refreshAllTabs, object: nil, queue: .main) { (notification) in
                  if self.boolStream {
                      self.viewControllers = [
                        self.generateViewController(rootViewController: HomeVC(), image:  #imageLiteral(resourceName: "home(1) 31"), title: ""),
                        self.generateViewController(rootViewController: SearchVC(), image:  #imageLiteral(resourceName: "search 51"), title: ""),
                        self.generateViewController(rootViewController: self.streamView ?? NotTokenView(), image:  #imageLiteral(resourceName: "Act1"),title: ""),
                        self.generateViewController(rootViewController: CategoryVC(), image:  #imageLiteral(resourceName: "Group 25931"), title: ""),
                        self.generateViewController(rootViewController: self.profile ?? StartScreen(), image:  #imageLiteral(resourceName: "user(2) 11") , title: "")


                      ]

                  } else {
                      self.viewControllers = [
                        self.generateViewController(rootViewController: HomeVC(), image:  #imageLiteral(resourceName: "home(1) 31"), title: ""),
                        self.generateViewController(rootViewController: SearchVC(), image:  #imageLiteral(resourceName: "search 51"), title: ""),
                        self.generateViewController(rootViewController: AddedVideoVC(), image:  #imageLiteral(resourceName: "Act1"),title: ""),
                        self.generateViewController(rootViewController: CategoryVC(), image:  #imageLiteral(resourceName: "Group 25931"), title: ""),
                        self.generateViewController(rootViewController: self.profile ?? StartScreen(), image:  #imageLiteral(resourceName: "user(2) 11") , title: "")


                      ]
                  }
              }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 15.0, *) {
               let appearance2 = UITabBarAppearance()
               appearance2.configureWithOpaqueBackground()
               appearance2.backgroundColor = .white //or whatever your color is

               tabBar.scrollEdgeAppearance = appearance2
               tabBar.standardAppearance = appearance2
           }
   

            self.navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.backgroundColor = .white
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()

            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
        
        
       
    }
    
    private func generateViewController(rootViewController: UIViewController,image: UIImage,title: String) -> UIViewController {
  
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.backgroundColor = .white
        return navigationVC
    }

}
