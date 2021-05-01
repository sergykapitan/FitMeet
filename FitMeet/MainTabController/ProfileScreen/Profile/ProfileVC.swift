//
//  ProfileVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    
    let profileView = ProfileVCCode()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override func loadView() {
        super.loadView()
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
    }
    func actionButtonContinue() {
        profileView.buttonLogOut.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
       // authView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
    }
    @objc func actionSignUp() {
        print("123")
        UserDefaults.standard.removeObject(forKey: Constants.accessTokenKeyUserDefaults)
        UserDefaults.standard.removeObject(forKey: Constants.userID)
        UserDefaults.standard.removeObject(forKey: Constants.chanellID)
        UserDefaults.standard.removeObject(forKey: Constants.userFullName)
        UserDefaults.standard.removeObject(forKey: Constants.broadcastID)
        UserDefaults.standard.removeObject(forKey: Constants.urlStream)
 
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
       // sceneDelegate.window!.rootViewController = viewController
       // sceneDelegate.window!.makeKeyAndVisible()
    }
    @objc func actionSignIn() {
//        let signUpVC = SignInViewController()
//        self.present(signUpVC, animated: true, completion: nil)
    }

}


