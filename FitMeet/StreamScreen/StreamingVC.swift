//
//  MainTabViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit

class StreamingVC: UIViewController {

        
        let streamView = StreamingVCCode()

        override func loadView() {
            super.loadView()
            view = streamView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            actionButtonContinue()
            view.backgroundColor = .lightText
        }
        func actionButtonContinue() {
 
        }
 

    }


    
    

