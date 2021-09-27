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

class SecurityCodeVC: UIViewController, CodeErrorDelegate {
    
    func codeError() {
        print("FRAMECode ===== \(self.securityView.buttonSendCode.frame.origin.y)")
        if self.securityView.buttonSendCode.frame.origin.y == 194.5 {
         
         UIView.animate(withDuration: 0.5) {
           self.securityView.buttonSendCode.frame.origin.y += 15
           self.securityView.alertLabel.text = "The security code is incorrect."
           self.securityView.alertImage.isHidden = false
           self.securityView.alertLabel.isHidden = false
            
         } completion: { (bool) in
             if bool {
                 
             }
         }
       }
    }
    
    
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetchannel: FitMeetChannels
    
    let securityView = SecurityCodeVCCode()
    var getHash: String?
    
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
        securityView.buttonSendCode.isUserInteractionEnabled = true
        actionButtonContinue()
        self.securityView.alertImage.isHidden = true
        self.securityView.alertLabel.isHidden = true
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
        guard let code = securityView.textFieldCode.text ,let phone = userPhoneOreEmail,let hash = getHash else { return }
        
        if phone.isValidPhone() {
            
            
            let vc = NewPassword()
            vc.verCode = code
            vc.userPhoneOreEmail = phone
            vc.getHash = hash
            vc.delegateCode = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
//        userSubscriber =  fitMeetApi.requestLogin(phoneCode: PhoneCode(phone: phone, verifyCode: code))
//            .mapError({ (error) -> Error in
//                print(error)
//                return error
//            })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                if let token = response.token?.token {
//                    UserDefaults.standard.set(token, forKey: Constants.accessTokenKeyUserDefaults)
//                    UserDefaults.standard.set(response.user?.id, forKey: Constants.userID)
//                    UserDefaults.standard.set(response.user?.fullName, forKey: Constants.userFullName)
//
//
//
//
//                   // self.openProfileViewController()
//             }
//        })
            
        } else {
            
        }
    }
}
extension SecurityCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      // let fullString = (textField.text ?? "") + string
        
        if  securityView.textFieldCode.text == "" {
            securityView.buttonSendCode.backgroundColor = UIColor(hexString: "#3B58A4")
            securityView.buttonSendCode.isUserInteractionEnabled = false
        } else {
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
