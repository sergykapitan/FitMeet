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
        self.actionOffline()
    }
    func actionButton () {
       // videoView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        videoView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        videoView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
      

    }

    //MARK: - Selectors
    @objc func actionOffline() {
       // videoView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        videoView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        videoView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        guard let userID = id else { return }
               buttonOffline.userId = userID
               buttonOffline.user = self.user

        removeAllChildViewController(buttonComming)
        configureChildViewController(buttonOffline, onView: videoView.selfView )
       
    }
    @objc func actionComming() {
        videoView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        videoView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        videoView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
        guard let userID = id else { return }
              buttonComming.userId = userID
              buttonComming.user = self.user

        removeAllChildViewController(buttonOffline)
        configureChildViewController(buttonComming, onView: videoView.selfView )
        
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

