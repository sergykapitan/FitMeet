//
//  VCcontroller.swift
//  FitMeet
//
//  Created by novotorica on 18.06.2021.
//

import Foundation
import UIKit


class VCcontroller: UIViewController {
    
    let searchView = VCControllerCode()
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionButtonContinue()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        actionButtonContinue()
        self.navigationItem.title = "Broadcast List"
        actionButtonContinue()
    }
    func actionButtonContinue() {
        let detailVC = NewStartStream()
       // detailVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
       // detailVC.popupDelegate = self
        self.present(detailVC, animated: true, completion: nil)
       
    }
    @objc func actionSignUp() {

    }
    @objc func actionSignIn() {

    }

}

