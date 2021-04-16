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
    let securityView = SecurityCodeVCCode()
    private var userSubscriber: AnyCancellable?
    var userPhoneOreEmail: String?
    
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

    private func fetchNewPassword(){
        guard let code = securityView.textFieldCode.text ,let phone = userPhoneOreEmail else { return }
        userSubscriber =  fitMeetApi.requestLogin(phoneCode: PhoneCode(phone: phone, verifyCode: code))
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print(response)
        
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
