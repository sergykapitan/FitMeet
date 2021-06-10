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
        self.navigationItem.title = "User Profile"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
        self.navigationController?.navigationBar.isHidden = false
    }
 
    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
        print("token ====== \(UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults))")
        profileView.userName.text = "User Name: \(userName)"
        profileView.chanellId.text = "User ID: \(userFullName)"
    }
    func actionButtonContinue() {
        profileView.buttonLogOut.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
    }
    @objc func actionSignUp() {
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

    }

}


