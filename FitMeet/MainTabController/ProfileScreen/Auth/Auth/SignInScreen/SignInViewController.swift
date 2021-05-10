//
//  SignInViewController.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import Foundation
import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    let signUpView = SignInViewControllerCode()
    private var userSubscriber: AnyCancellable?
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func loadView() {
        super.loadView()
        view = signUpView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.textFieldLogin.delegate = self
        signUpView.buttonContinue.isUserInteractionEnabled = false
        actionButtonContinue()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    func actionButtonContinue() {
        signUpView.buttonContinue.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        signUpView.buttonSignUp.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
    }
    @objc func actionContinue() {
        let userPhoneOreMail = signUpView.textFieldLogin.text
        let signInVC = SignInPasswordViewController()
        signInVC.userPhoneOreEmail = userPhoneOreMail
        self.present(signInVC, animated: true, completion: nil)
    }
    @objc func actionSignUp() {
        self.dismiss(animated: true, completion: nil)
    }

}
extension SignInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            signUpView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            signUpView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            signUpView.buttonContinue.backgroundColor = UIColor(hexString: "0099AE")
            signUpView.buttonContinue.isUserInteractionEnabled = true
        } else {
            signUpView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            signUpView.buttonContinue.isUserInteractionEnabled = false
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpView.textFieldLogin {
            self.signUpView.textFieldLogin.resignFirstResponder()
        }
        return true
    }
}
