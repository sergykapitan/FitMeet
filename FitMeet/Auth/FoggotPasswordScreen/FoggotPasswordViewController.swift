//
//  FoggotPasswordViewController.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class FoggotPasswordViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    let passwordView = FoggotPasswordViewControllerCode()
    private var userSubscriber: AnyCancellable?
    
    override func loadView() {
        super.loadView()
        view = passwordView
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.textFieldLogin.delegate = self
        passwordView.buttonContinue.isUserInteractionEnabled = false
        actionButtonContinue()
    }
    func actionButtonContinue() {
        passwordView.buttonContinue.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        passwordView.buttonSignIn.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
    }
    @objc func actionContinue() {
        
        let securityCode = SecurityCode()
        let hostVC = UIHostingController(rootView: securityCode)
        hostVC.modalPresentationStyle = .fullScreen
        self.present(hostVC, animated: true, completion: nil)
        fetchSicurityCode()
    }
    @objc func actionSignIn() {
        
        let securityCode = SecurityCode()
        let hostVC = UIHostingController(rootView: securityCode)
        hostVC.modalPresentationStyle = .fullScreen
        self.present(hostVC, animated: true, completion: nil)
  
    }
    private func fetchSicurityCode(){
        guard let phone = passwordView.textFieldLogin.text else { return }
        
        print("PHONNNEEEE ===== \(phone)")
        
      //  fitMeetApi.requestSecurityCodeNN(phone: Phone(phone: phone))
        
        userSubscriber = fitMeetApi.requestSecurityCode(phone: Phone(phone: phone  ))
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("GGGGGGGGGGGGGGGGGG = \(response)")
        })
    }
}
extension FoggotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        let string = "formate"
        textField.text = string.format(phoneNumber: fullString, shouldRemoveLastDigt: range.length == 1)
        if fullString == "" {
            passwordView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            passwordView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            passwordView.buttonContinue.backgroundColor = UIColor(hexString: "0099AE")
            passwordView.buttonContinue.isUserInteractionEnabled = true
        } else {
            passwordView.buttonContinue.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            passwordView.buttonContinue.isUserInteractionEnabled = false
        }

        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordView.textFieldLogin {
            self.passwordView.textFieldLogin.resignFirstResponder()
        }
        return true
    }
    
}
