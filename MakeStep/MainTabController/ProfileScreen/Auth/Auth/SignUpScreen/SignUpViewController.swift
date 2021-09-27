//
//  SignUpViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit
import Combine
import Alamofire

protocol SignUpDelegate: class {
    
    func changeAlert()
    func changeMail()
    func changePhone()

}

class SignUpViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetChannel: FitMeetChannels
    
    let signUpView = SignUpViewControllerCode()
    private var userSubscriber: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeAppleSign: AnyCancellable?
    
    typealias CompletionHandler = ( _ success:Bool) -> Void
    weak var delegate: SignUpDelegate?
    
    var userPhoneOreEmail: String?
    
    private let minLeght = 8
    private var regex = "^[\\d!#$%&*@^-]*$"
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
        signUpView.textFieldName.delegate = self
        signUpView.textFieldUserName.delegate = self
        signUpView.textFieldPassword.delegate = self
        signUpView.textFieldPassword.textContentType = .password
        self.signUpView.textFieldPassword.isSecureTextEntry = true
        buttonSignUp()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signUpView.alertLabel.isHidden = true
        signUpView.alertImage.isHidden = true
    }
    func buttonSignUp() {
        signUpView.buttonContinue.addTarget(self, action: #selector(buttonSignUpAction), for: .touchUpInside)
    }
    @objc func buttonSignUpAction() {
        fetchUser()
    }
    private func openProfileViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
 
    private func fetchUser(){
        if signUpView.textFieldName.text == "" || signUpView.textFieldUserName.text == "" || signUpView.textFieldPassword.text == "" {
            //print("ведите значения для текста")
            self.alertControl(message: "Error TextField")
            return
        }
        guard let phone = userPhoneOreEmail , let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text else { return }
        
        if phone.isValidPhone() {
                userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                                                     fullName: name,
                                                                                     username: usr,
                                                                                     phone: phone,
                                                                                     password: password ))
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let token = response.token?.token {
                UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                    self.openProfileViewController()
                } else if response.message == "error.user.phoneExist"{
                    self.delegate?.changeAlert()
                    self.dismiss(animated: true, completion: nil)
                } else if response.message == "error.user.emailExist" {
                    self.delegate?.changeMail()
                    self.dismiss(animated: true, completion: nil)
                } else if response.message == "phone must be a valid phone number" {
                    self.delegate?.changePhone()
                    self.dismiss(animated: true, completion: nil)
                }
                else if response.message == "error.user.usernameExist"{
                    
                    print("HHHH ==\(self.signUpView.textFieldPassword.frame.origin.y)")
                    
                    if self.signUpView.textFieldPassword.frame.origin.y == 209.0 {
                    
                    UIView.animate(withDuration: 0.5) {
                      self.signUpView.textFieldPassword.frame.origin.y += 15
                      self.signUpView.buttonContinue.frame.origin.y += 15
                      self.signUpView.textPrivacyPolice.frame.origin.y += 15
                    } completion: { (bool) in
                        if bool {
                            self.signUpView.alertImage.isHidden = false
                            self.signUpView.alertLabel.isHidden = false
                        }
                    }
                  }
                } else if response.message != nil {
                    self.alertControl(message: "\(String(describing: response.message))")
                }
            
           })
            
        } else {
            
            userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                        fullName: name,
                                                        username: usr,
                                                        email: phone,
                                                        password: "\(password)"
            ))
                .mapError({ (error) -> Error in
                            return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    print("RESPONCE====\(response)")
                    if let token = response.token?.token {
                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                    UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                    UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                        self.openProfileViewController()
                    } else if response.message == "error.user.phoneExist"{
                        
                        self.delegate?.changeAlert()
                        self.dismiss(animated: true, completion: nil)
                      
                    } else if response.message == "error.user.emailExist" {
                        
                        self.delegate?.changeMail()
                        self.dismiss(animated: true, completion: nil)
                        
                    } else if response.message == "error.user.usernameExist"{
                        if self.signUpView.textFieldPassword.frame.origin.y == 209.0 {
                        UIView.animate(withDuration: 0.5) {
                          self.signUpView.textFieldPassword.frame.origin.y += 15
                          self.signUpView.buttonContinue.frame.origin.y += 15
                          self.signUpView.textPrivacyPolice.frame.origin.y += 15
                        } completion: { (bool) in
                            if bool {
                                self.signUpView.alertImage.isHidden = false
                                self.signUpView.alertLabel.isHidden = false
                            }
                        }
                      }
                    } else if response.message != nil {
                        self.alertControl(message: "\(String(describing: response.message))")
                    }
              })
           }
        }

    private func alertControl(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
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
            if fullString.isValidPassword() {
                return true
            }
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
