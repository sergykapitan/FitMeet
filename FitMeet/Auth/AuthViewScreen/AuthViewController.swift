//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    
    private let maximumNumber = 64
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
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
    private func format(phoneNumber:String,shouldRemoveLastDigt: Bool) -> String {
        
        guard !(shouldRemoveLastDigt && phoneNumber.count <= 2) else { return ""}
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number  = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maximumNumber {
            let maxIndex = number.index(number.startIndex, offsetBy: maximumNumber)
            number = String(number[number.startIndex..<maxIndex])
        }
        if shouldRemoveLastDigt {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        let maxIndex = number.index(number.startIndex,offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "+$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "+$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
       return number
    }
}
extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            authView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            authView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhoneM() || fullString.isValidEmailN() {
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

