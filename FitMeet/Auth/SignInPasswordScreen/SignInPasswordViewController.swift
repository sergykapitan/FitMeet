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
    var userPhoneOreEmail: String?
    
    override func loadView() {
        super.loadView()
        view = signUpView
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    private func fetchUser(){
        guard let fff = userPhoneOreEmail else { return }
        print("JJJJJJJJJ=====\(fff)")
       // userSubscriber = fitMeetApi.requestSomeStuff(authRequest: <#T##AuthorizationRequest#>)
    }
}
