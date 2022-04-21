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
    private var userSubscriber: AnyCancellable?
    
    let passwordView = FoggotPasswordViewControllerCode()
    
    
    
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func loadView() {
        super.loadView()
        view = passwordView
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.textFieldLogin.delegate = self
        passwordView.buttonContinue.isUserInteractionEnabled = false
        passwordView.textFieldLogin.keyboardType = .numberPad
        actionButtonContinue()
        self.passwordView.alertImage.isHidden = true
        self.passwordView.alertLabel.isHidden = true
        self.hideKeyboardWhenTappedAround() 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    func actionButtonContinue() {
        passwordView.buttonContinue.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        passwordView.buttonSignUp.addTarget(self, action: #selector(actionSignIn), for: .touchUpInside)
    }
    @objc func actionContinue() {
       fetchSicurityCode()

    }
    @objc func actionSignIn() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    private func fetchSicurityCode() {
        guard let phone = passwordView.textFieldLogin.text else { return }
        let userPhoneOreMail = phone.format(phoneNumber: phone, shouldRemoveLastDigt: phone.count == 1)
            userSubscriber = fitMeetApi.resetPassword(phone: Phone(phone: userPhoneOreMail ))
                .mapError({ (error) -> Error in
                    print(error)
                    return error
                })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    print(response)
                    if response.hash != nil {
                        let userPhoneOreMail = phone.format(phoneNumber: phone, shouldRemoveLastDigt: phone.count == 1)
                        let securityCode = SecurityCodeVC()
                        securityCode.getHash = response.hash
                        securityCode.userPhoneOreEmail = userPhoneOreMail
                        self.present(securityCode, animated: true, completion: nil)

                    } else if response.message == "phone must be a valid phone number" {
                        if self.passwordView.buttonContinue.frame.origin.y == 209.0 {
                         
                         UIView.animate(withDuration: 0.5) {
                           self.passwordView.buttonContinue.frame.origin.y += 15
                           self.passwordView.labelAccount.frame.origin.y += 15
                           self.passwordView.buttonSignUp.frame.origin.y += 15
                         } completion: { (bool) in
                             if bool {
                                 self.passwordView.alertImage.isHidden = false
                                 self.passwordView.alertLabel.text = "phone must be a valid phone number"
                                 self.passwordView.alertLabel.isHidden = false
                             }
                         }
                      }
                    } else if response.message == "error.user.notFound" {
                        if self.passwordView.buttonContinue.frame.origin.y == 209.0 {
                         
                         UIView.animate(withDuration: 0.5) {
                           self.passwordView.buttonContinue.frame.origin.y += 15
                           self.passwordView.labelAccount.frame.origin.y += 15
                           self.passwordView.buttonSignUp.frame.origin.y += 15
                         } completion: { (bool) in
                             if bool {
                                 self.passwordView.alertImage.isHidden = false
                                 self.passwordView.alertLabel.text = "phone must be a valid phone number"
                                 self.passwordView.alertLabel.isHidden = false
                             }
                         }
                      }
                  }
            })
    }
}
extension FoggotPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
    
        if fullString == "" {
            passwordView.buttonContinue.backgroundColor = .blueColor.alpha(0.4)
            passwordView.buttonContinue.isUserInteractionEnabled = false
        } else if  fullString.isValidPhone() || fullString.isValidEmail() {
            passwordView.buttonContinue.backgroundColor = .blueColor
            passwordView.buttonContinue.isUserInteractionEnabled = true
        } else {
            passwordView.buttonContinue.backgroundColor = .blueColor.alpha(0.4)
            passwordView.buttonContinue.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordView.textFieldLogin {
            self.passwordView.textFieldLogin.resignFirstResponder()
        }
        return true
    }
    
}
