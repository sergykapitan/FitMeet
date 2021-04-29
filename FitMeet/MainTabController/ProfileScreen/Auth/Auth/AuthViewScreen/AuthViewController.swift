//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func loadView() {
        super.loadView()
        view = authView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authView.textFieldLogin.delegate = self
        actionButtonContinue()
        authView.buttonContinue.isUserInteractionEnabled = false
    }
    func actionButtonContinue() {
        authView.buttonContinue.addTarget(self, action: #selector(actionSignUp), for: .touchUpInside)
        authView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
    }
    @objc func actionSignUp() {
        let userPhoneOreMail = authView.textFieldLogin.text
        let signUpVC = SignUpViewController()
        signUpVC.userPhoneOreEmail = userPhoneOreMail
        self.present(signUpVC, animated: true, completion: nil)
    }
    @objc func actionSignIn() {
        let signUpVC = SignInViewController()
        self.present(signUpVC, animated: true, completion: nil)
    }
//    override func shouldAutorotate() -> Bool {
//        // Return an array of ViewControllers that are children of the parent
//        let childViewControllersArray = self.children
//        if childViewControllersArray.count > 0 {
//            // Assume childVC is the ViewController you are interested in NOT allowing to rotate
//            let childVC = childViewControllersArray.first
//            if childVC is ChildViewController {
//            return false
//            }
//        }
//        return true
//    }
}
extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            authView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            authView.buttonContinue.backgroundColor = UIColor(hexString: "0099AE")
            authView.buttonContinue.isUserInteractionEnabled = true
        } else {
            authView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == authView.textFieldLogin {
            self.authView.textFieldLogin.resignFirstResponder()
        }
        return true
    }  
}

extension UINavigationController {
//    public override func shouldAutorotate() -> Bool {
//        if visibleViewController is AuthViewController {
//            return true   // rotation
//        } else {
//            return false  // no rotation
//        }
//    }
//
//    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return (visibleViewController?.supportedInterfaceOrientations)!
//    }
}