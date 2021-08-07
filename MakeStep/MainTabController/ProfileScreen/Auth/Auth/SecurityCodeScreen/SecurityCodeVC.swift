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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
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
        
        if phone.isValidPhone() {
        userSubscriber =  fitMeetApi.requestLogin(phoneCode: PhoneCode(phone: phone, verifyCode: code))
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let token = response.token?.token {
                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
                    UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
                    UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
                    self.openProfileViewController()
             }
        })
        } else {
            
        }
    }
}
extension SecurityCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       let fullString = (textField.text ?? "") + string
        
     if  fullString != nil {
            securityView.buttonSendCode.backgroundColor = UIColor(hexString: "#3B58A4")
            securityView.buttonSendCode.isUserInteractionEnabled = true
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