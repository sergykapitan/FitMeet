//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    
    override func loadView() {
        super.loadView()
        view = authView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.textFieldLogin.delegate = self
        
    }
}
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        if textField.text == "" {
            print("Enter either valid phone or email 1")
        } else if let validphone = textField.text, validphone.isValidPhone() || validphone.isValidEmail() {
            print("Success")
        } else {
          print("Enter either valid phone or email 2")
        }
      }
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
      textField.resignFirstResponder()

        return true
    }
}

