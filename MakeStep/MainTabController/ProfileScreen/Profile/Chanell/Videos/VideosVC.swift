//
//  VideosVC.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
//

import Foundation
import UIKit
import Combine
import AudioToolbox

class VideosVC: UIViewController {

   
    let videoView = VideosVCCode()
    let buttonOffline = ButtonOffline()
    let buttonComming = ButtonCommingg()
    
    var id: Int?
    var user: User?

 
    override func loadView() {
        super.loadView()
        view = videoView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionButton()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    func actionButton () {
       // videoView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        videoView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        videoView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
      

    }

    //MARK: - Selectors
    @objc func actionOffline() {
    
        
        removeAllChildViewController(buttonComming)
        configureChildViewController(buttonOffline, onView: videoView.selfView )
        guard let userID = id else { return }
        buttonOffline.userId = userID
        buttonOffline.user = self.user


    }
    @objc func actionComming() {
        removeAllChildViewController(buttonOffline)
        configureChildViewController(buttonComming, onView: videoView.selfView )
        
        guard let userID = id else { return }
        buttonComming.userId = userID
        buttonComming.user = self.user
   
    }
    private func vibrate() {
        if #available(iOS 10.0, *) {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

