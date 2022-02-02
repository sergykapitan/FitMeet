//
//  LandscapeWindow.swift
//  Pods
//
//  Created by Millman YANG on 2017/8/24.
//
//

import UIKit




private class WindowViewController: UIViewController {
    var isStatusHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusHidden
    }
}

public class MMLandscapeWindow: UIWindow {
    unowned let playerLayer: MMPlayerLayer
    let play = MMPlayerLayer()
    weak var originalPlayView: UIView?
    var completed: (()->Void)?
    
    public init(playerLayer: MMPlayerLayer) {
        self.playerLayer = playerLayer
        super.init(frame: .zero)
        self.setup()
    }
    
    required  init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.frame = UIScreen.main.bounds
        self.update()
    }
    
}

extension MMLandscapeWindow {
    private func setup() {
        self.rootViewController = WindowViewController()
        self.backgroundColor = UIColor.clear
 
    }

    func update() {
        switch self.playerLayer.orientation {
    case .protrait:
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.playerLayer.playView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            })
            transitionAnimator.startAnimation()
      
    case .landscapeRight, .landscapeLeft:
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.playerLayer.playView?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            
            })
            transitionAnimator.startAnimation()
        }
    }
    private var isPlayOnSelf: Bool {
        return self.playerLayer.playView == self.rootViewController?.view
    }
}
