//
//  SecurityCodeVC.swift
//  FitMeet
//
//  Created by novotorica on 16.04.2021.
//

import Foundation
import Combine
import UIKit
import Alamofire

class SecurityCodeVC: UIViewController {
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetchannel: FitMeetChannels
    
    let securityView = SecurityCodeVCCode()
    
    private var userSubscriber: AnyCancellable?
    private var takeListChannel: AnyCancellable?
    private var takeChannel: AnyCancellable?
    
    var userPhoneOreEmail: String?
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func loadView() {
        super.loadView()
        view = securityView
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        securityView.textFieldCode.delegate = self
        securityView.textFieldCode.keyboardType = .numberPad
        securityView.buttonSendCode.isUserInteractionEnabled = false
        actionButtonContinue()
    }
    func actionButtonContinue() {
        securityView.buttonSendCode.addTarget(self, action: #selector(actionSendCode), for: .touchUpInside)
    }
    @objc func actionSendCode() {
        fetchNewPassword()
    }
    private func openProfileViewController() {
        let viewController = MainTabBarViewController()
        viewController.selectedIndex = 4
        let mySceneDelegate = (self.view.window?.windowScene)!
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.openRootViewController(viewController: viewController, windowScene: mySceneDelegate)
    }
    private func fetchNewPassword(){
        guard let code = securityView.textFieldCode.text ,let phone = userPhoneOreEmail else { return }
        userSubscriber =  fitMeetApi.requestLogin(phoneCode: PhoneCode(phone: phone, verifyCode: code))
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let token = response.token?.token {
                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                    guard let userName = response.user?.username else { return }
                    self.fetchListChannel(userName: userName)
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
                    self.openProfileViewController()
                } else {
                    self.fetchChannel(name: userName, title: userName, description: userName)
            }
        })
    }
   private func fetchChannel(name: String,title: String,description: String) {
         takeChannel = fitMeetchannel.createChannel(channel:  ChannelRequest(name: name, title: title, description: description , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
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
extension SecurityCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       let fullString = (textField.text ?? "") + string
       if fullString == "" {
            securityView.buttonSendCode.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            securityView.buttonSendCode.isUserInteractionEnabled = false
        } else if  fullString.isValidCode() {
            securityView.buttonSendCode.backgroundColor = UIColor(hexString: "0099AE")
            securityView.buttonSendCode.isUserInteractionEnabled = true
        } else {
            securityView.buttonSendCode.backgroundColor = UIColor(red: 0, green: 0.601, blue: 0.683, alpha: 0.5)
            securityView.buttonSendCode.isUserInteractionEnabled = false
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == securityView.textFieldCode {
            self.securityView.textFieldCode.resignFirstResponder()
        }
        return true
    }
    
}
