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
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    let chanellId = UserDefaults.standard.string(forKey: Constants.chanellID)
    
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
        setUserProfile()
        actionButtonContinue()
        makeNavItem()
        profileView.scroll.delegate = self
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserProfile()
        self.navigationController?.navigationBar.isHidden = false
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUserProfile()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
       
        print("Token = \(token)")
        print("ChanelId = \(chanellId)")
        
    }
    func setUserProfile() {
        guard let userName = UserDefaults.standard.string(forKey: Constants.userFullName) else { return }
        bindingUser()
        let name: String?
        if user?.fullName != nil { name = user?.fullName
        } else { name = userName }
        guard let name = name else { return }
        profileView.welcomeLabel.text = name
        
    }
    func actionButtonContinue() {
        profileView.buttonSignOut.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        profileView.buttonProfile.addTarget(self, action: #selector(actionEditProfile), for: .touchUpInside)
        profileView.buttonChanell.addTarget(self, action: #selector(actionChanell), for: .touchUpInside)
        profileView.buttonCommunityGuidelines.addTarget(self, action: #selector(actionTerms), for:.touchUpInside )
        profileView.buttonCookiePolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
        profileView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionDMCA), for: .touchUpInside)
        profileView.buttonSecurity.addTarget(self, action: #selector(actionDisclaimer), for: .touchUpInside)
        profileView.buttonWallet.addTarget(self, action: #selector(actionMonetezation), for: .touchUpInside)
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
    @objc func actionMonetezation() {
        let vc = MonetezeitionVC()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    //1
    @objc func actionAbout() {
        let helpWebViewController = WebViewController()
      //  helpWebViewController.url = Constants.webViewPwa + "about"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    //3
       @objc func actionTerms() {
           let helpWebViewController = WebViewController()
           helpWebViewController.url = Constants.webViewPwa + "terms_of_service"
           self.navigationController?.pushViewController(helpWebViewController, animated: true)
       }
    //4
    @objc func actionPrivacyPolicy() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "privacy_policy"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    //5
    @objc func actionDMCA() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "dmca"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    //6
    @objc func actionDisclaimer() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "disclaimer"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
   

    func bindingUser() {
        take = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    self.profileView.setImageLogo(image: response.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
                }
        })
    }
    @objc func actionEditProfile() {
        let editProfile = EditProfile()
        editProfile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    @objc func actionChanell() {
        let channelUs = ChanellVC()
        channelUs.user = self.user
        channelUs.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(channelUs, animated: true)
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
        
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
      //  self.navigationItem.rightBarButtonItems = [startItem,timeTable]
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


