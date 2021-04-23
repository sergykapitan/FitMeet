//
//  SignUpViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    let signUpView = SignUpViewControllerCode()
    private var userSubscriber: AnyCancellable?
    var userPhoneOreEmail: String?
    private let minLeght = 8
    private var regex = "^[\\d!#$%&*@^-]*$"
    
    
    override func loadView() {
        super.loadView()
        view = signUpView
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.textFieldName.delegate = self
        signUpView.textFieldUserName.delegate = self
        signUpView.textFieldPassword.delegate = self
        signUpView.textFieldPassword.textContentType = .password
        buttonSignUp()
  
    }
    func buttonSignUp() {
        signUpView.buttonContinue.addTarget(self, action: #selector(buttonSignUpAction), for: .touchUpInside)
    }
    @objc func buttonSignUpAction() {
        fetchUser()
    }
    private func fetchUser(){
        guard let phone = userPhoneOreEmail , let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text else { return }
        userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                    fullName: name,
                                                    username: usr,
                                                    email: "12kaptan122345@gmail.com",
                                                    phone: phone,
                                                    password: password))
            .mapError({ (error) -> Error in
                        print(error)
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                UserDefaults.standard.set(response.token?.token, forKey: Constants.accessTokenKeyUserDefaults)
                self.openMainViewController()
            })
            
    }
    private func checkValidation(password: String) {
        guard password.count >= minLeght else { return }
        if password.matches(regex) {
            print("Validate")
        } else {
            print("NotValidate")
        }
    }
    private func openMainViewController() {
          let mainVC = MainTabBarViewController()
          mainVC.modalPresentationStyle = .fullScreen
          self.present(mainVC, animated: true, completion: nil)
    }
}
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    if textField == signUpView.textFieldPassword {
        let fullString = (textField.text ?? "") + string
        let res: String
        
        if range.length == 1{
            let end  = fullString.index(fullString.startIndex, offsetBy: fullString.count - 1)
            res = String(fullString[fullString.startIndex..<end])
        } else {
            res = fullString
        }
        checkValidation(password: res)
        textField.text = res
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.signUpView.textFieldPassword.resignFirstResponder()
        self.signUpView.textFieldName.resignFirstResponder()
        self.signUpView.textFieldUserName.resignFirstResponder()
        
        return true
    }
  
}
