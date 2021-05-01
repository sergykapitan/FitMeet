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

class SignUpViewController: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetChannel: FitMeetChannels
    
    let signUpView = SignUpViewControllerCode()
    private var userSubscriber: AnyCancellable?
    private var takeChannel: AnyCancellable?
    
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
        guard let phone = userPhoneOreEmail , let name = signUpView.textFieldName.text, let usr = signUpView.textFieldUserName.text, let password = signUpView.textFieldPassword.text else { return }
        
        if phone.isValidPhone() {
            
        
        
        userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                    fullName: name,
                                                    username: usr,
                                                    phone: phone,
                                                    password: password
        ))
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let token = response.token?.token {
                UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                guard let userName = response.user?.fullName else { return }
                    self.openProfileViewController()
               // self.fetchChannel(name: userName, title: userName, description: userName)
                } else if response.message?.first == "error.user.phoneExist"{
                print("такой email уже существует")
                } else if response.message?.first == "error.user.emailExist" {
                print("такой телефон уже существует")
                }else if response.message?.first == "error.user.usernameExist"{
                print("такое имя пользователя уже существует")
            }
          })
            
        } else {
            
            userSubscriber = fitMeetApi.signupPassword(authRequest: AuthorizationRequest(
                                                        fullName: name,
                                                        username: usr,
                                                        email: phone,
                                                        password: password
            ))
                .mapError({ (error) -> Error in
                            return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if let token = response.token?.token {
                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                    UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                    UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                    guard let userName = response.user?.username else { return }
                        self.openProfileViewController()
                 //   self.fetchChannel(name: userName, title: userName, description: userName)
                    } else if response.message?.first == "error.user.phoneExist"{
                    print("такой email уже существует")
                    } else if response.message?.first == "error.user.emailExist" {
                    print("такой телефон уже существует")
                    }else if response.message?.first == "error.user.usernameExist"{
                    print("такое имя пользователя уже существует")
                }
              })
           }
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
   func fetchChannel(name: String,title: String,description: String) {
        takeChannel = fitMeetChannel.createChannel(channel:  ChannelRequest(name: name, title: title, description: description , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let idChanell = response.id {
                    print("Create Chanell")
                    UserDefaults.standard.set(idChanell, forKey: Constants.chanellID)
                    self.openProfileViewController()
              }
        })
    }
}
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    if textField == signUpView.textFieldPassword {
        let fullString = (textField.text ?? "") + string

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
