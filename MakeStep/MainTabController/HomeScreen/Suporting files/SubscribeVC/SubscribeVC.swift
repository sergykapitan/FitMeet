//
//  SubscribeVC.swift
//  MakeStep
//
//  Created by novotorica on 20.08.2021.
//

import Foundation
import UIKit

class SubscribeVC: UIViewController {
    
    let subscribeView = SubscribeVCCode()
    
    override func loadView() {
        view = subscribeView
        self.view.backgroundColor = UIColor.white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
}

