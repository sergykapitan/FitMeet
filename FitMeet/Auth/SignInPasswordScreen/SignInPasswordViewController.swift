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
    let signUpView = SignInPasswordViewControllerCode()
    private var userSubscriber: AnyCancellable?
  
    
    override func loadView() {
        super.loadView()
        view = signUpView
        actionButtonContinue()
    }
    func actionButtonContinue() {
        signUpView.buttonSignIn.addTarget(self, action: #selector(actionContinue), for: .touchUpInside)
        signUpView.buttonFoggotPassword.addTarget(self, action: #selector(actionFoggotPassword), for: .touchUpInside)
    }
    @objc func actionContinue() {
       
    }
    @objc func actionFoggotPassword() {
        let passwordVC = FoggotPasswordViewController()
        passwordVC.modalPresentationStyle = .fullScreen
        self.present(passwordVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private func fetchUser(){
       // userSubscriber = fitMeetApi.requestSomeStuff(authRequest: <#T##AuthorizationRequest#>)
    }
}
