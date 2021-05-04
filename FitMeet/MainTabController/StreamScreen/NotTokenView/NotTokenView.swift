//
//  NotTokenView.swift
//  FitMeet
//
//  Created by novotorica on 04.05.2021.
//

import Foundation
import UIKit

class NotTokenView: UIViewController {
    
    let searchView = NotTkenViewCode()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        actionButtonContinue()
    }
    func actionButtonContinue() {
       // authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
       // authView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
    }
    @objc func actionSignUp() {
//        let userPhoneOreMail = authView.textFieldLogin.text
//        let signUpVC = SignUpViewController()
//        signUpVC.userPhoneOreEmail = userPhoneOreMail
//        self.present(signUpVC, animated: true, completion: nil)
    }
    @objc func actionSignIn() {
//        let signUpVC = SignInViewController()
//        self.present(signUpVC, animated: true, completion: nil)
    }

}

