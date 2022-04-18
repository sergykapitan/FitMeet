//
//  StartScreen.swift
//  FitMeet
//
//  Created by novotorica on 22.06.2021.
//

import Combine
import UIKit

class StartScreen: UIViewController,UITabBarControllerDelegate, UIScrollViewDelegate {
     
    let homeView = StartScreenCode()

    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Connectivity.isConnectedToInternet {
            return } else {
                let vc = NotInternetView()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        homeView.buttonSignUp.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonSignIn.backgroundColor = UIColor(hexString: "#BBBCBC")
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeNavItem()
        navigationItem.largeTitleDisplayMode = .always
        homeView.scroll.delegate = self
        actionButtonContinue()
    

    }
    func actionButtonContinue() {
      homeView.buttonSignUp.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
      homeView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
      homeView.buttonCommunityGuidelines.addTarget(self, action: #selector(actionTerms), for:.touchUpInside )
      homeView.buttonCookiePolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
      homeView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionDMCA), for: .touchUpInside)
      homeView.buttonSecurity.addTarget(self, action: #selector(actionDisclaimer), for: .touchUpInside)
      homeView.buttonWallet.addTarget(self, action: #selector(actionMonetezation), for: .touchUpInside)
      homeView.buttonPartners.addTarget(self, action: #selector(actionHowIt), for: .touchUpInside)
      homeView.buttonAbout.addTarget(self, action: #selector(actionAbout), for: .touchUpInside)
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
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(rightHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(rightHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc func rightHandAction() {
        print("right bar button action")
    }
    @objc func leftHandAction() {
        print("left bar button action")
    }
    @objc func actionMonetezation() {
        let vc = MonetezeitionVC()
        self.navigationController?.pushViewController(vc, animated: true)

    }
  
    @objc func actionSignUp() {
        homeView.buttonSignUp.backgroundColor = .blueColor
        homeView.buttonSignIn.backgroundColor = UIColor(hexString: "#BBBCBC")
        let auth = AuthViewController()
        self.present(auth, animated: true, completion: nil)
    }

    @objc func actionSignIn() {
        homeView.buttonSignIn.backgroundColor = .blueColor
        homeView.buttonSignUp.backgroundColor = UIColor(hexString: "#BBBCBC")
        let sign = SignInViewController()
        self.present(sign, animated: true, completion: nil)
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

}
