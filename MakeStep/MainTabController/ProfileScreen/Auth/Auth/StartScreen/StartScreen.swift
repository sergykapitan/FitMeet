//
//  StartScreen.swift
//  FitMeet
//
//  Created by novotorica on 22.06.2021.
//

import Combine
import UIKit

class StartScreen: UIViewController,CustomSegmentedControlDelegate,UITabBarControllerDelegate, UIScrollViewDelegate {
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if index == 0 {
            let auth = AuthViewController()
            self.present(auth, animated: true, completion: nil)
           
        }
        if index == 1 {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            
        }

    }
 
    let homeView = StartScreenCode()


    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeNavItem()
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Sign Up","Sign In"])
        homeView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        homeView.scroll.delegate = self
        actionButtonContinue()
    

    }
    func actionButtonContinue() {

      homeView.buttonCommunityGuidelines.addTarget(self, action: #selector(actionTerms), for:.touchUpInside )
      homeView.buttonCookiePolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
      homeView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionDMCA), for: .touchUpInside)
      homeView.buttonSecurity.addTarget(self, action: #selector(actionDisclaimer), for: .touchUpInside)
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
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
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

}
