//
//  NotTokenView.swift
//  FitMeet
//
//  Created by novotorica on 04.05.2021.
//

import Foundation
import UIKit

class NotTokenView: UIViewController {
    
    let searchView = NotTkenViewCode()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        actionButtonContinue()
        self.navigationItem.title = "Broadcast List"
    }
    func actionButtonContinue() {

    }
    @objc func actionSignUp() {

    }
    @objc func actionSignIn() {

    }

}

