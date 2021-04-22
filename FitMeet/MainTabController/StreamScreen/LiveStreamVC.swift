//
//  LiveStreamVC.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation
import UIKit
class LiveStreamVC: UIViewController {
    let liveStreamView = LiveStreamVCCode()
    
    override func loadView() {
        super.loadView()
        view = liveStreamView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
    }
    
    func actionButton() {
        liveStreamView.videoModeButton.addTarget(self, action: #selector(nextView), for: .touchUpInside)
    }
    
    @objc func nextView() {
        
    }
    
    
    
    
    
}
