//
//  ProfileVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit
import Combine

class ProfileVC: SheetableViewController, UIScrollViewDelegate {
    
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
        if Connectivity.isConnectedToInternet {
            return } else {
                let vc = NotInternetView()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc .delegate = self
                self.present(vc, animated: true, completion: nil)
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
        profileView.buttonWallet.addTarget(self, action: #selector(actionMonetezation), for: .touchUpInside)
        profileView.buttonEditChanell.addTarget(self, action: #selector(actionEditChanell), for: .touchUpInside)

        profileView.buttonCommunityGuidelines.addTarget(self, action: #selector(actionTerms), for:.touchUpInside )
        profileView.buttonCookiePolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
        profileView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionDMCA), for: .touchUpInside)
        profileView.buttonSecurity.addTarget(self, action: #selector(actionDisclaimer), for: .touchUpInside)
        profileView.buttonContact.addTarget(self, action: #selector(actionContact), for: .touchUpInside)
        
        profileView.buttonPartners.addTarget(self, action: #selector(actionHowIt), for: .touchUpInside)
        profileView.buttonAbout.addTarget(self, action: #selector(actionAbout), for: .touchUpInside)
        profileView.buttonDelAkk.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
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
    @objc func deleteAccount() {
        showDownSheet(deleteAccountSheetVC,payload: nil)
    }
    override func stopLoaf() {
        self.actionSignUp()
    }
    @objc func actionMonetezation() {
        let vc = MonetezeitionVC()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @objc func actionAbout() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = "https://dev.makestep.com/about-us-webview/"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    
    @objc func actionHowIt() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = "https://join.makestep.com"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    @objc func actionTerms() {
           let helpWebViewController = WebViewController()
           helpWebViewController.url = Constants.webViewPwa + "terms_of_service"
           self.navigationController?.pushViewController(helpWebViewController, animated: true)
       }
    @objc func actionPrivacyPolicy() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "privacy_policy"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    @objc func actionDMCA() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "dmca"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    @objc func actionDisclaimer() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "disclaimer"
        self.navigationController?.pushViewController(helpWebViewController, animated: true)
    }
    @objc func actionContact() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = "https://dev.makestep.com/contact_us_webview"
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
    @objc func actionEditChanell() {
        let vc = EdetChannelVC()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    }
}

extension ProfileVC: ReloadView {
    func reloadView() {
        if self.user == nil {
             self.setUserProfile()
         }
    }
}
extension ProfileVC:Refreshable {
    func refresh() {
        print("refresh")
    }
}
