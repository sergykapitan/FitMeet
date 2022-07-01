//
//  SignInPasswordViewController.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import Foundation
import UIKit
import Combine

protocol SignInDelegate: class {
    
    func changeAlert()
    func changeMail()

}


class SignInPasswordViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetchannel: FitMeetChannels
    
    let signUpView = SignInPasswordViewControllerCode()
    private var userSubscriber: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeListChannel: AnyCancellable?
    typealias CompletionHandler = ( _ success:Bool) -> Void
    
    weak var delegate: SignInDelegate?
    
    var userPhoneOreEmail: String?
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
        actionButtonContinue()
        signUpView.textFieldLogin.delegate = self
        signUpView.textFieldLogin.textContentType = .password
        signUpView.textFieldLogin.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround() 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signUpView.alertLabel.isHidden = true
        signUpView.alertImage.isHidden = true
        
    }
    func actionButtonContinue() {
        signUpView.buttonSignIn.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        signUpView.buttonFoggotPassword.addTarget(self, action: #selector(actionFoggotPassword), for: .touchUpInside)
    }
    @objc func actionContinue() {
        fetchUser()
    }
    @objc func actionFoggotPassword() {
//        weak var pvc = self.presentingViewController
//        self.dismiss(animated: true, completion: {
//            let signUpVC = AuthViewController()
//            pvc?.present(signUpVC, animated: true, completion: nil)
//        })
        let passwordVC = FoggotPasswordViewController()
     //   passwordVC.modalPresentationStyle = .fullScreen
        self.present(passwordVC, animated: true, completion: nil)
    }
 
    private func fetchUser(){
        guard let phoneOreMail = userPhoneOreEmail,let password = signUpView.textFieldLogin.text else { return }
        
        if phoneOreMail.isValidPhone() {
            userSubscriber = fitMeetApi.loginPassword(login: LoginPassword(phone: phoneOreMail, password: password))
            .mapError({ (error) -> Error in
               return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let token = response.token?.token {
                UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                    self.openMainViewController()
                } else {
                    if response.message == "error.password.incorrect" {
                      
                        if self.signUpView.buttonSignIn.frame.origin.y == 155.0 {
                        UIView.animate(withDuration: 0.5) {
                          self.signUpView.buttonSignIn.frame.origin.y += 15
                          self.signUpView.buttonFoggotPassword.frame.origin.y += 15
                        } completion: { (bool) in
                            if bool {
                                self.signUpView.alertImage.isHidden = false
                                self.signUpView.alertLabel.isHidden = false
                            }
                        }
                      }
                    } else if response.message == "error.user.notFound" {
                        self.delegate?.changeAlert()
                        self.dismiss(animated: true, completion: nil)
                       // self.alertControl(message: "User Not Found")
                    }
                }
            })
        } else {
            userSubscriber = fitMeetApi.loginPassword(login: LoginPassword(email: phoneOreMail, password: password))
                .mapError({ (error) -> Error in
                   return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if let token = response.token?.token {
                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                    UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                    UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                        self.openMainViewController()
                    } else {
                        if response.message == "error.password.incorrect" {
                         
                            if self.signUpView.buttonSignIn.frame.origin.y == 155.0 {
                            UIView.animate(withDuration: 0.5) {
                              self.signUpView.buttonSignIn.frame.origin.y += 15
                              self.signUpView.buttonFoggotPassword.frame.origin.y += 15
                            } completion: { (bool) in
                                if bool {
                                    self.signUpView.alertImage.isHidden = false
                                    self.signUpView.alertLabel.isHidden = false
                                }
                            }
                          }
                        } else if response.message == "error.user.notFound" {
                            self.delegate?.changeMail()
                            self.dismiss(animated: true, completion: nil)
                           // self.alertControl(message: "User Not Found")
                        }
                    }
             })
        }
    }
    private func openMainViewController() {
        if let tab = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController as? MainTabBarViewController {
           tab.boolStream = true
           NotificationCenter.default.post(Notification(name: .refreshAllTabs))
           tab.selectedIndex = 4
       }
//        let viewController = MainTabBarViewController()
//       // viewController.selectedIndex = 4
//        let mySceneDelegate = (self.view.window?.windowScene)!
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
 
    
    private func alertControl(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
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
