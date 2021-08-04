//
//  ProfileVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit
import Combine

class ProfileVC: UIViewController, UIScrollViewDelegate {
    
    let profileView = ProfileVCCode()
    private var take: AnyCancellable?
 
    @Inject var fitMeetApi: FitMeetApi
    var user: User?
    
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
        makeNavItem()
        profileView.scroll.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
    }
 
    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName),let userFullName = UserDefaults.standard.string(forKey: Constants.userID) else { return }
        print("token ====== \(UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults))")
        bindingUser()
        let name: String?
        if user?.fullName != nil {
            name = user?.fullName
        } else { name = userName }
        guard let n = name else { return }
        profileView.welcomeLabel.text = "Hi! " + n
        
    }
    func actionButtonContinue() {
       profileView.buttonSignOut.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
       profileView.buttonProfile.addTarget(self, action: #selector(actionEditProfile), for: .touchUpInside)
        profileView.buttonChanell.addTarget(self, action: #selector(actionChanell), for: .touchUpInside)
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
    func bindingUser() {
        take = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    print(self.user)
                }
        })
    }
    @objc func actionEditProfile() {
        let editProfile = EditProfile()
        editProfile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    @objc func actionChanell() {
        let editProfile = ChanellVC()
        editProfile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Profile"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
}


