//
//  StartScreen.swift
//  FitMeet
//
//  Created by novotorica on 22.06.2021.
//

import Combine
import UIKit

class StartScreen: UIViewController,CustomSegmentedControlDelegate,UITabBarControllerDelegate {
    
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
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Sign Up  ","  Sign In"])
        homeView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        
    

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
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }

}
