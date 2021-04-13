//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    
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
    }
    @objc func actionSignUp() {
        let signUpVC = SignUpViewController()
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    
    
}
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing === началось редактирование")
        
      }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        print("textFieldShouldEndEditing === закончил редактировать")
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("можно ли редактирровать")
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "" {
            authView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        } else if let validphone = textField.text, validphone.isValidPhone() || validphone.isValidEmail() {
                    print("Success")
            authView.buttonContinue.backgroundColor = UIColor(hexString: "0099AE")
            authView.buttonContinue.isUserInteractionEnabled = true
        } else {
            authView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        }
    
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}

