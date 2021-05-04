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
    @Inject var fitMeetchannel: FitMeetChannels
    
    let signUpView = SignInPasswordViewControllerCode()
    private var userSubscriber: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeListChannel: AnyCancellable?
    
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
        
        if phone.isValidPhone() {
        
            userSubscriber = fitMeetApi.loginPassword(login: LoginPassword(phone: phone, password: password))
            .mapError({ (error) -> Error in
                   print(error)
               return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print(response)
                UserDefaults.standard.set(response.token?.token, forKey: Constants.accessTokenKeyUserDefaults)
                UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                guard let userName = response.user?.username else { return }
                self.fetchListChannel(userName: userName)
                
                
         })
        } else {
            userSubscriber = fitMeetApi.loginPassword(login: LoginPassword(
                                                        phone: phone,
                                                        password: password))
                .mapError({ (error) -> Error in
                       print(error)
                   return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    print(response)
                    UserDefaults.standard.set(response.token?.token, forKey: Constants.accessTokenKeyUserDefaults)
                    guard let userName = response.user?.username else { return }
                    self.fetchListChannel(userName: userName)
                    
               
             })
        }
    }
    private func openMainViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
    func fetchChannel(name: String,title: String,description: String) {
         takeChannel = fitMeetchannel.createChannel(channel:  ChannelRequest(name: name, title: title, description: description , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
             .mapError({ (error) -> Error in
                         return error })
             .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let idChanell = response.id {
                     print("Create Chanell")
                     UserDefaults.standard.set(idChanell, forKey: Constants.chanellID)
                     self.openMainViewController()
               }
         })
    }
    private func fetchListChannel(userName: String) {
        takeListChannel = fitMeetchannel.listChannels()
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let idChanell = response.data.last?.id {
                    print("Take id Chanell")
                    UserDefaults.standard.set(idChanell, forKey: Constants.chanellID)
                    self.openMainViewController()
                } else {
                    self.fetchChannel(name: userName, title: userName, description: userName)
                }
        })
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
