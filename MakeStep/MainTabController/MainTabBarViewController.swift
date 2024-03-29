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
    var boolStream: Bool  = true
    let actionChatTransitionManager = ActionTransishionChatManadger()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .blueColor
        self.tabBar.barTintColor = .white
        self.delegate = self
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
        
        if token != nil {
            profile = ProfileVC()
           // guard let boolStream = boolStream else { return}
            print("Bool = \(boolStream)")
            if boolStream {
                streamView = LiveStreamViewController()
            } else {
                streamView = AddedVideoVC()
            }//NewStartStream()
            viewControllers = [
                generateViewController(rootViewController: HomeVC(), image: #imageLiteral(resourceName: "home(1) 31"), title: ""),
                generateViewController(rootViewController: LiveVC(), image: #imageLiteral(resourceName: "Act1"), title: ""),
                generateViewController(rootViewController: streamView ?? NotTokenView() , image: #imageLiteral(resourceName: "StreamN") , title: ""),
                generateViewController(rootViewController: CategoryVC(), image: #imageLiteral(resourceName: "Group 25931"), title: ""),
                generateViewController(rootViewController: profile ?? StartScreen(), image: #imageLiteral(resourceName: "user(2) 11") , title: "")
            ]

        } else {
            profile = StartScreen()
            streamView = NotTokenView()
            viewControllers = [
                generateViewController(rootViewController: HomeVC(), image: #imageLiteral(resourceName: "home(1) 31"), title: ""),
                generateViewController(rootViewController: LiveVC(), image: #imageLiteral(resourceName: "Act1"), title: ""),
                generateViewController(rootViewController: CategoryVC(), image: #imageLiteral(resourceName: "Group 25931"), title: ""),
                generateViewController(rootViewController: profile ?? StartScreen(), image: #imageLiteral(resourceName: "user(2) 11") , title: "")
            ]
        }
    }
    deinit {
           NotificationCenter.default.removeObserver(self)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .refreshAllTabs, object: nil, queue: .main) { (notification) in
          //  guard let boolStream = self.boolStream else { return }

            if self.boolStream {
                      self.viewControllers = [
                        self.generateViewController(rootViewController: HomeVC(), image:  #imageLiteral(resourceName: "home(1) 31"), title: ""),
                        self.generateViewController(rootViewController: LiveVC(), image:  #imageLiteral(resourceName: "Act1"), title: ""),
                        self.generateViewController(rootViewController: LiveStreamViewController(), image:  #imageLiteral(resourceName: "StreamN"),title: ""),
                        self.generateViewController(rootViewController: CategoryVC(), image:  #imageLiteral(resourceName: "Group 25931"), title: ""),
                        self.generateViewController(rootViewController: ProfileVC(), image:  #imageLiteral(resourceName: "user(2) 11") , title: "")


                      ]

                  } else {
                      self.viewControllers = [
                        self.generateViewController(rootViewController: HomeVC(), image:  #imageLiteral(resourceName: "home(1) 31"), title: ""),
                        self.generateViewController(rootViewController: LiveVC(), image:  #imageLiteral(resourceName: "Act1"), title: ""),
                        self.generateViewController(rootViewController: AddedVideoVC(), image:  #imageLiteral(resourceName: "StreamN"),title: ""),
                        self.generateViewController(rootViewController: CategoryVC(), image:  #imageLiteral(resourceName: "Group 25931"), title: ""),
                        self.generateViewController(rootViewController: ProfileVC(), image:  #imageLiteral(resourceName: "user(2) 11") , title: "")


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
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let vcIndex = tabBarController.viewControllers!.firstIndex(of: viewController)!
      let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
           if  vcIndex == 2 {
               if token != nil {
               let chatVC = SendStream()
               let curvaView = tabBarController.selectedViewController!
               chatVC.transitioningDelegate = actionChatTransitionManager
               chatVC.modalPresentationStyle = .custom
               actionChatTransitionManager.intWidth = 1
               actionChatTransitionManager.intHeight = 0.25
               curvaView.present(chatVC, animated: true, completion: nil)

               return false
               } else {
                   return true
               }
           } else {
               return true
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
