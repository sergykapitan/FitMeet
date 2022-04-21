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
        animateError()
    }
    
    
    @Inject var fitMeetApi: FitMeetApi
    let securityView = SecurityCodeVCCode()
    var getHash: String?
    private var codeReview: AnyCancellable?
    var bottomConstraint = NSLayoutConstraint()
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
        self.hideKeyboardWhenTappedAround()
        bottomConstraint = securityView.buttonSendCode.topAnchor.constraint(equalTo: securityView.textFieldCode.bottomAnchor, constant: 15)
        bottomConstraint.isActive = true
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
            codeReview = fitMeetApi.codeReview(hashs: Hashs(hash: hash), code: code)
                .mapError({ (error) -> Error in
                    self.animateError()
                    return error  })
                .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    if response != nil {
                                let vc = NewPassword()
                                vc.verCode = code
                                vc.userPhoneOreEmail = phone
                                vc.getHash = hash
                                vc.delegateCode = self
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                    }
                })
            }
        }
    private func animateError() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
            self.bottomConstraint.constant = 65
            self.securityView.alertLabel.text = "The security code is incorrect."
            self.securityView.alertImage.isHidden = false
            self.securityView.alertLabel.isHidden = false
            
            })
            self.view.layoutIfNeeded()
        transitionAnimator.startAnimation()
    }
}
extension SecurityCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
        if  securityView.textFieldCode.text == "" {
            securityView.buttonSendCode.backgroundColor = .blueColor.alpha(0.4)
            securityView.buttonSendCode.isUserInteractionEnabled = false
        } else {
            securityView.buttonSendCode.backgroundColor = .blueColor
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
