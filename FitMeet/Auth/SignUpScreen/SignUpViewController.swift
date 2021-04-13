//
//  SignUpViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let signUpView = SignUpViewControllerCode()
    
    override func loadView() {
        super.loadView()
        view = signUpView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
}
