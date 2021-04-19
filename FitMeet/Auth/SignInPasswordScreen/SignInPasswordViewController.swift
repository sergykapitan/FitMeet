//
//  SignInPasswordViewController.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit
import Combine

class SignInPasswordViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    let signUpView = SignInPasswordViewControllerCode()
    private var userSubscriber: AnyCancellable?
    var userPhoneOreEmail: String?
    
    override func loadView() {
        super.loadView()
        view = signUpView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()        
        actionButtonContinue()
        signUpView.textFieldLogin.delegate = self
    }
    func actionButtonContinue() {
        signUpView.buttonSignIn.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        signUpView.buttonFoggotPassword.addTarget(self, action: #selector(actionFoggotPassword), for: .touchUpInside)
    }
    @objc func actionContinue() {
        fetchUser()
    }
    @objc func actionFoggotPassword() {
        let passwordVC = FoggotPasswordViewController()
        passwordVC.modalPresentationStyle = .fullScreen
        self.present(passwordVC, animated: true, completion: nil)
    }
 
    private func fetchUser(){
        guard let phone = userPhoneOreEmail,let password = signUpView.textFieldLogin.text else { return }
        userSubscriber = fitMeetApi.loginPassword(login: LoginPassword(
                                                    email: "developersergy@gmail.com",
                                                    username: "Kapitan",
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
    private func openMainViewController() {
          let mainVC = MainTabBarViewController()
          mainVC.modalPresentationStyle = .fullScreen
          self.present(mainVC, animated: true, completion: nil)
    }
}
extension SignInPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    if textField == signUpView.textFieldLogin {
        let fullString = (textField.text ?? "") + string

        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.signUpView.textFieldLogin.resignFirstResponder()
        return true
    }
  
}
