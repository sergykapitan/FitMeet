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
    
    var nameConstraint = NSLayoutConstraint()
    var userNameConstraint = NSLayoutConstraint()
    var passwordConstraint = NSLayoutConstraint()
    
    
   
    
    
    
    let signUpView = SignUpViewControllerCode()
    private var userSubscriber: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeAppleSign: AnyCancellable?
    
    typealias CompletionHandler = ( _ success:Bool) -> Void
    weak var delegate: SignUpDelegate?
    
    var userPhoneOreEmail: String?
    var validation = Validation()
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
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signUpView.alertLabel.isHidden = true
        signUpView.alertImage.isHidden = true
    }
    
    func buttonSignUp() {
        signUpView.buttonContinue.addTarget(self, action: #selector(buttonSignUpAction), for: .touchUpInside)
        signUpView.buttonTerms.addTarget(self, action: #selector(actionTerms), for:.touchUpInside )
        signUpView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
        signUpView.buttonPrivacyDMCA.addTarget(self, action: #selector(actionDMCA), for: .touchUpInside)
        
        nameConstraint = signUpView.textFieldUserName.topAnchor.constraint(equalTo: signUpView.textFieldName.bottomAnchor, constant: 15)
        nameConstraint.isActive = true
        
        userNameConstraint = signUpView.textFieldPassword.topAnchor.constraint(equalTo: signUpView.textFieldUserName.bottomAnchor, constant: 15)
        userNameConstraint.isActive = true
        
        passwordConstraint = signUpView.buttonContinue.topAnchor.constraint(equalTo: signUpView.textFieldPassword.bottomAnchor, constant: 15)
        passwordConstraint.isActive = true

    }
    @objc func actionTerms() {
           let helpWebViewController = WebViewController()
           helpWebViewController.url = Constants.webViewPwa + "terms_of_service"
           self.present(helpWebViewController, animated: true, completion: nil)
       }
   
    @objc func actionPrivacyPolicy() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "privacy_policy"
        self.present(helpWebViewController, animated: true, completion: nil)
    }

    @objc func actionDMCA() {
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "dmca"
        self.present(helpWebViewController, animated: true, completion: nil)
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
        guard let phone = userPhoneOreEmail, let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text
           else { return }

        let isValidateName = self.validation.validateName(name: name)
        if (isValidateName == false) {
            animateName()
           print("Incorrect Name")
           return
        }
        if (isValidateName == true) {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                
                self.nameConstraint.constant = 15
                self.signUpView.alertImage.isHidden = true
                self.signUpView.alertLabel.isHidden = true
  
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
    }
        let isValidateUserName = self.validation.validateUserName(userName: usr)
        if (isValidateUserName == false){
           print("Incorrect UserName")
            animateUserName()
           return
        }
        if (isValidateUserName == true){
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                
                self.userNameConstraint.constant = 15
                self.signUpView.alertImage2.isHidden = true
                self.signUpView.alertLabel2.isHidden = true
  
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
        }
        let isValidatePass = self.validation.validatePassword(password: password)
        if (isValidatePass == false) {
            animatePassword()
           print("Incorrect Pass")
           return
        }
        if (isValidatePass == true) {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                
                self.passwordConstraint.constant = 15
                self.signUpView.alertImage3.isHidden = true
                self.signUpView.alertLabel3.isHidden = true
  
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
        }
        
        if (isValidateName == true || isValidateUserName == true || isValidatePass == true ) {
           print("All fields are correct")
        }
     
//        guard let phone = userPhoneOreEmail , let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text else { return }

        if phone.isValidPhone() {
                userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                                                     fullName: name,
                                                                                     username: usr,
                                                                                     phone: phone,
                                                                                     password: password ))
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("RES == \(response)")
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
    private func animateName() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.nameConstraint.constant = 45
            self.signUpView.alertImage.isHidden = false
            self.signUpView.alertLabel.isHidden = false
            
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
    }
    private func animateUserName() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.userNameConstraint.constant = 45
            self.signUpView.alertImage2.isHidden = false
            self.signUpView.alertLabel2.isHidden = false
            
            
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
    }
    private func animatePassword() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            
            self.passwordConstraint.constant = 45
            self.signUpView.alertImage3.isHidden = false
            self.signUpView.alertLabel3.isHidden = false
            
            
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
    }

}
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.signUpView.textFieldName {
            let maxLength = 120
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == self.signUpView.textFieldPassword {
            let maxLength = 64
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == self.signUpView.textFieldUserName {
            let maxLength = 64
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.signUpView.textFieldPassword.resignFirstResponder()
        self.signUpView.textFieldName.resignFirstResponder()
        self.signUpView.textFieldUserName.resignFirstResponder()
        
        return true
    }
}
