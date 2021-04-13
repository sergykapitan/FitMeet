//
//  ViewController.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import UIKit
import SwiftUI

class AuthViewController: UIViewController {
    
    let authView = AuthViewControllerCode()
    
    override func loadView() {
        super.loadView()
        view = authView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

