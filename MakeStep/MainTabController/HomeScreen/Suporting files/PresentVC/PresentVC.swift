//
//  PresentVC.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//


import Combine
import UIKit
import AVKit
import Presentr

private enum State {
    case closed
    case open
}
 
extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}


class PresentVC: UIViewController, ClassBDelegate, CustomSegmentedControlDelegate, ClassBVCDelegate, ClassUserDelegate, CustomSegmentedFullControlDelegate{

    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    private var bottomConstraint = NSLayoutConstraint()
    
    private var topConstraint = NSLayoutConstraint()
    private var leftConstant = NSLayoutConstraint()
    private var botConstant = NSLayoutConstraint()
    private var centerConstant = NSLayoutConstraint()
    
    private var heightConstant = NSLayoutConstraint()
    private var widthConstant = NSLayoutConstraint()
    
    private var topWelcomLabelConstant = NSLayoutConstraint()
    private var leftWelcomeLabelConstant = NSLayoutConstraint()
    private var centerWelcomeLabelConstant = NSLayoutConstraint()
    
    private var topOverlayConstant = NSLayoutConstraint()
    private var rightLandscape = NSLayoutConstraint()
    
    private var topbuttonSubscribeConstant = NSLayoutConstraint()
    private var leftbuttonSubscribeConstant = NSLayoutConstraint()
    private var rightbuttonSubscribeConstant = NSLayoutConstraint()
    private var centerbuttonSubscribeConstant = NSLayoutConstraint()
    
    
       private func layout() {
        homeView.viewTop.translatesAutoresizingMaskIntoConstraints = false
        homeView.imageLogoProfile.translatesAutoresizingMaskIntoConstraints = false
        homeView.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        homeView.labelFollow.translatesAutoresizingMaskIntoConstraints = false
        homeView.buttonSubscribe.translatesAutoresizingMaskIntoConstraints = false
        homeView.buttonHelpCoach.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(homeView.viewTop)
        view.addSubview(homeView.imageLogoProfile)
        view.addSubview(homeView.welcomeLabel)
        view.addSubview(homeView.labelFollow)
        view.addSubview(homeView.buttonHelpCoach)
        
        view.addSubview(homeView.buttonSubscribe)
        view.addSubview(homeView.buttonFollow)
        view.addSubview(homeView.buttonInstagram)
        view.addSubview(homeView.buttonTwiter)
        view.addSubview(homeView.buttonfaceBook)
        view.addSubview(homeView.labelINTVideo)
        view.addSubview(homeView.labelVideo)
        view.addSubview(homeView.labelINTFollows)
        view.addSubview(homeView.labelFollows)
        view.addSubview(homeView.labelINTFolowers)
        view.addSubview(homeView.labelFolowers)
        view.addSubview(homeView.labelDescription)
        
        self.homeView.buttonSubscribe.isHidden = false
        self.homeView.buttonFollow.isHidden = true
        self.homeView.buttonInstagram.isHidden = true
        self.homeView.buttonTwiter.isHidden = true
        self.homeView.buttonfaceBook.isHidden = true
        self.homeView.labelINTVideo.isHidden = true
        self.homeView.labelVideo.isHidden = true
        self.homeView.labelINTFollows.isHidden = true
        self.homeView.labelFollows.isHidden = true
        self.homeView.labelINTFolowers.isHidden = true
        self.homeView.labelFolowers.isHidden = true
        self.homeView.labelDescription.isHidden = true
        

        homeView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = homeView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: -400)
        bottomConstraint.isActive = true
        homeView.viewTop.heightAnchor.constraint(equalToConstant: 500).isActive = true

        homeView.labelFollow.bottomAnchor.constraint(equalTo: homeView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
        homeView.labelFollow.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 12).isActive = true
        

        topWelcomLabelConstant = homeView.welcomeLabel.topAnchor.constraint(equalTo: homeView.imageLogoProfile.topAnchor, constant: 0)
        topWelcomLabelConstant.isActive = true
        
        leftWelcomeLabelConstant = homeView.welcomeLabel.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 15)
        leftWelcomeLabelConstant.isActive = true
        
        centerWelcomeLabelConstant = homeView.welcomeLabel.centerXAnchor.constraint(equalTo: homeView.cardView.centerXAnchor)
        centerWelcomeLabelConstant.isActive = false
        

        leftConstant = homeView.imageLogoProfile.leadingAnchor.constraint(equalTo: homeView.viewTop.leadingAnchor, constant: 20)
        leftConstant.isActive = true
        
        
        botConstant = homeView.imageLogoProfile.bottomAnchor.constraint(equalTo: homeView.viewTop.bottomAnchor, constant: -20)
        botConstant.isActive = true
        
        topConstraint = homeView.imageLogoProfile.topAnchor.constraint(equalTo: homeView.viewTop.topAnchor, constant: 120)
        topConstraint.isActive = false
        
        centerConstant = homeView.imageLogoProfile.centerXAnchor.constraint(equalTo: homeView.viewTop.centerXAnchor)
        centerConstant.isActive = false
        
        heightConstant = homeView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
        heightConstant.isActive = true
        widthConstant = homeView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
        widthConstant.isActive = true
        
        
        topbuttonSubscribeConstant = homeView.buttonSubscribe.topAnchor.constraint(equalTo: homeView.welcomeLabel.bottomAnchor, constant: 20)
        topbuttonSubscribeConstant.isActive = false
        leftbuttonSubscribeConstant = homeView.buttonSubscribe.leadingAnchor.constraint(equalTo: homeView.viewTop.leadingAnchor, constant: 18)
        leftbuttonSubscribeConstant.isActive = false
        rightbuttonSubscribeConstant = homeView.buttonSubscribe.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -10)
        rightbuttonSubscribeConstant.isActive = true
        centerbuttonSubscribeConstant = homeView.buttonSubscribe.centerYAnchor.constraint(equalTo: homeView.imageLogoProfile.centerYAnchor)
        centerbuttonSubscribeConstant.isActive = true
        
        
        homeView.buttonSubscribe.anchor( width: 100, height: 28)
        
        
        homeView.buttonFollow.anchor(top: homeView.welcomeLabel.bottomAnchor, paddingTop: 20, width: 102, height: 28)
        homeView.buttonFollow.centerX(inView: homeView.viewTop)
 
       
        homeView.buttonInstagram.anchor(  right: homeView.cardView.rightAnchor,paddingRight: 17, width: 28, height: 28)
        homeView.buttonInstagram.centerY(inView: homeView.buttonSubscribe)
        
        
        
        homeView.buttonTwiter.anchor(right: homeView.buttonInstagram.leftAnchor,paddingRight: 8,  width: 28, height: 28)
        homeView.buttonTwiter.centerY(inView: homeView.buttonInstagram)

        
        homeView.buttonfaceBook.anchor( right: homeView.buttonTwiter.leftAnchor, paddingRight: 8, width: 28, height: 28)
        homeView.buttonfaceBook.centerY(inView: homeView.buttonInstagram)
        
        
        homeView.labelINTVideo.anchor(top: homeView.buttonSubscribe.bottomAnchor, left: homeView.viewTop.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
        
        homeView.labelVideo.anchor(top: homeView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelVideo.centerX(inView: homeView.labelINTVideo)
        
        
        
        homeView.labelINTFollows.anchor(top: homeView.buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
        homeView.labelINTFollows.centerX(inView: homeView.buttonFollow)
        
        
        homeView.labelFollows.anchor(top: homeView.labelINTFollows.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelFollows.centerX(inView: homeView.viewTop)
        
        
        
        
        homeView.labelINTFolowers.anchor(top: homeView.buttonSubscribe.bottomAnchor, right: homeView.viewTop.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
        
        homeView.labelFolowers.anchor(top: homeView.labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelFolowers.centerX(inView: homeView.labelINTFolowers)
        
        
        homeView.labelDescription.anchor(top: homeView.labelFollows.bottomAnchor, left: homeView.viewTop.leftAnchor, right: homeView.cardView.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
        
        homeView.buttonHelpCoach.anchor(bottom:homeView.viewTop.bottomAnchor,paddingBottom: -5,width: 40, height: 30)
        homeView.buttonHelpCoach.centerX(inView: homeView.viewTop)
       
       }
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
           let recognizer = UITapGestureRecognizer()
           recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
           return recognizer
       }()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: homeView.viewTop)
            var fraction = -translation.y / 400
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: homeView.viewTop).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                print("OPEN First")
                self.bottomConstraint.constant = -400
                self.heightConstant.constant = 70
                self.widthConstant.constant = 70
                self.topConstraint.isActive = false
                self.centerConstant.isActive = false
                self.leftConstant.isActive = true
                self.botConstant.isActive = true
                self.topWelcomLabelConstant.isActive = true
                self.leftWelcomeLabelConstant.isActive = true
                self.topWelcomLabelConstant.constant = 0
                self.centerWelcomeLabelConstant.isActive = false
                self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 14)
                self.homeView.labelFollow.isHidden = false
                
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true
                
             self.homeView.imageLogoProfile.makeRounded()
             
            // self.homeView.buttonSubscribe.isHidden = true
             self.homeView.buttonFollow.isHidden = true
             self.homeView.buttonInstagram.isHidden = true
             self.homeView.buttonTwiter.isHidden = true
             self.homeView.buttonfaceBook.isHidden = true
             self.homeView.labelINTVideo.isHidden = true
             self.homeView.labelVideo.isHidden = true
             self.homeView.labelINTFollows.isHidden = true
             self.homeView.labelFollows.isHidden = true
             self.homeView.labelINTFolowers.isHidden = true
             self.homeView.labelFolowers.isHidden = true
             self.homeView.labelDescription.isHidden = true
             
            case .closed:
                print("close First")
                self.heightConstant.constant = 90
                self.widthConstant.constant = 90
                self.bottomConstraint.constant = -100
                self.centerConstant.isActive = true
                self.topConstraint.isActive = true
                self.leftConstant.isActive = false
                self.botConstant.isActive = false
                self.leftWelcomeLabelConstant.isActive = false
                self.topWelcomLabelConstant.constant = 105
                self.centerWelcomeLabelConstant.isActive = true
                self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                self.homeView.labelFollow.isHidden = true
                
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true
                
                
                
                
             self.homeView.imageLogoProfile.makeRounded()
             //self.homeView.buttonSubscribe.isHidden = false
             self.homeView.buttonFollow.isHidden = false
             self.homeView.buttonInstagram.isHidden = false
             self.homeView.buttonTwiter.isHidden = false
             self.homeView.buttonfaceBook.isHidden = false
             self.homeView.labelINTVideo.isHidden = false
             self.homeView.labelVideo.isHidden = false
             self.homeView.labelINTFollows.isHidden = false
             self.homeView.labelFollows.isHidden = false
             self.homeView.labelINTFolowers.isHidden = false
             self.homeView.labelFolowers.isHidden = false
             self.homeView.labelDescription.isHidden = false
             
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = -400
                self.heightConstant.constant = 70
                self.widthConstant.constant = 70
                self.topConstraint.isActive = false
                self.centerConstant.isActive = false
                self.leftConstant.isActive = true
                self.botConstant.isActive = true
                self.topWelcomLabelConstant.isActive = true
                self.leftWelcomeLabelConstant.isActive = true
                self.topWelcomLabelConstant.constant = 0
                self.centerWelcomeLabelConstant.isActive = false
                self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 14)
                self.homeView.labelFollow.isHidden = false
                
                self.rightbuttonSubscribeConstant.isActive = true
                self.centerbuttonSubscribeConstant.isActive = true
                self.topbuttonSubscribeConstant.isActive = false
                self.leftbuttonSubscribeConstant.isActive = false
                
             self.homeView.imageLogoProfile.makeRounded()
             
            // self.homeView.buttonSubscribe.isHidden = true
             self.homeView.buttonFollow.isHidden = true
             self.homeView.buttonInstagram.isHidden = true
             self.homeView.buttonTwiter.isHidden = true
             self.homeView.buttonfaceBook.isHidden = true
             self.homeView.labelINTVideo.isHidden = true
             self.homeView.labelVideo.isHidden = true
             self.homeView.labelINTFollows.isHidden = true
             self.homeView.labelFollows.isHidden = true
             self.homeView.labelINTFolowers.isHidden = true
             self.homeView.labelFolowers.isHidden = true
             self.homeView.labelDescription.isHidden = true
             
            case .closed:
                self.heightConstant.constant = 90
                self.widthConstant.constant = 90
                self.bottomConstraint.constant = -100
                self.centerConstant.isActive = true
                self.topConstraint.isActive = true
                self.leftConstant.isActive = false
                self.botConstant.isActive = false
                self.leftWelcomeLabelConstant.isActive = false
                self.topWelcomLabelConstant.constant = 105
                self.centerWelcomeLabelConstant.isActive = true
                self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                self.homeView.labelFollow.isHidden = true
                
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                
           //  self.homeView.imageLogoProfile.makeRounded()
            // self.homeView.buttonSubscribe.isHidden = false
             self.homeView.buttonFollow.isHidden = false
             self.homeView.buttonInstagram.isHidden = false
             self.homeView.buttonTwiter.isHidden = false
             self.homeView.buttonfaceBook.isHidden = false
             self.homeView.labelINTVideo.isHidden = false
             self.homeView.labelVideo.isHidden = false
             self.homeView.labelINTFollows.isHidden = false
             self.homeView.labelFollows.isHidden = false
             self.homeView.labelINTFolowers.isHidden = false
             self.homeView.labelFolowers.isHidden = false
             self.homeView.labelDescription.isHidden = false
             
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.homeView.labelVideo.alpha = 1
            case .closed:
                self.homeView.labelVideo.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.homeView.labelVideo.alpha = 0
            case .closed:
                self.homeView.labelVideo.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }
    
       @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
           let state = currentState.opposite
           let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
               switch state {
               
               case .open:
                print("OPEN First")
                self.rightbuttonSubscribeConstant.isActive = true
                self.centerbuttonSubscribeConstant.isActive = true
                self.topbuttonSubscribeConstant.isActive = false
                self.leftbuttonSubscribeConstant.isActive = false
                
                   self.bottomConstraint.constant = -400
                   self.heightConstant.constant = 70
                   self.widthConstant.constant = 70
                   self.topConstraint.isActive = false
                   self.centerConstant.isActive = false
                   self.leftConstant.isActive = true
                   self.botConstant.isActive = true
                   self.topWelcomLabelConstant.isActive = true
                   self.leftWelcomeLabelConstant.isActive = true
                   self.topWelcomLabelConstant.constant = 0
                   self.centerWelcomeLabelConstant.isActive = false
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 14)
                   self.homeView.labelFollow.isHidden = false
                
                
                
                self.homeView.imageLogoProfile.makeRounded()
                

                self.homeView.buttonFollow.isHidden = true
                self.homeView.buttonInstagram.isHidden = true
                self.homeView.buttonTwiter.isHidden = true
                self.homeView.buttonfaceBook.isHidden = true
                self.homeView.labelINTVideo.isHidden = true
                self.homeView.labelVideo.isHidden = true
                self.homeView.labelINTFollows.isHidden = true
                self.homeView.labelFollows.isHidden = true
                self.homeView.labelINTFolowers.isHidden = true
                self.homeView.labelFolowers.isHidden = true
                self.homeView.labelDescription.isHidden = true
                
               case .closed:
                print("close First")
                
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true

                   self.heightConstant.constant = 90
                   self.widthConstant.constant = 90
                   self.bottomConstraint.constant = -100
                   self.centerConstant.isActive = true
                   self.topConstraint.isActive = true
                   self.leftConstant.isActive = false
                   self.botConstant.isActive = false
                   self.leftWelcomeLabelConstant.isActive = false
                   self.topWelcomLabelConstant.constant = 105
                   self.centerWelcomeLabelConstant.isActive = true
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                   self.homeView.labelFollow.isHidden = true
                self.homeView.imageLogoProfile.makeRounded()
                self.homeView.buttonFollow.isHidden = false
                self.homeView.buttonInstagram.isHidden = false
                self.homeView.buttonTwiter.isHidden = false
                self.homeView.buttonfaceBook.isHidden = false
                self.homeView.labelINTVideo.isHidden = false
                self.homeView.labelVideo.isHidden = false
                self.homeView.labelINTFollows.isHidden = false
                self.homeView.labelFollows.isHidden = false
                self.homeView.labelINTFolowers.isHidden = false
                self.homeView.labelFolowers.isHidden = false
                self.homeView.labelDescription.isHidden = false
                
                
                
               }
               self.view.layoutIfNeeded()
           })
           transitionAnimator.addCompletion { position in
               switch position {
               case .start:
                   self.currentState = state.opposite
               case .end:
                   self.currentState = state
               case .current:
                   ()
               @unknown default:
                print("Defoult")
               }
               switch self.currentState {
               
               case .open:
                print("OPEN Second")
                self.rightbuttonSubscribeConstant.isActive = true
                self.centerbuttonSubscribeConstant.isActive = true
                self.topbuttonSubscribeConstant.isActive = false
                self.leftbuttonSubscribeConstant.isActive = false
                
                   self.bottomConstraint.constant = -400
                   self.topConstraint.isActive = false
                   self.centerConstant.isActive = false
                   self.leftConstant.isActive = true
                   self.botConstant.isActive = true
                   self.heightConstant.constant = 70
                   self.widthConstant.constant = 70
                   self.topWelcomLabelConstant.isActive = true
                   self.leftWelcomeLabelConstant.isActive = true
                   self.topWelcomLabelConstant.constant = 0
                   self.centerWelcomeLabelConstant.isActive = false
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 14)
                   self.homeView.labelFollow.isHidden = false
                self.homeView.imageLogoProfile.makeRounded()
               
                self.homeView.buttonFollow.isHidden = true
                self.homeView.buttonInstagram.isHidden = true
                self.homeView.buttonTwiter.isHidden = true
                self.homeView.buttonfaceBook.isHidden = true
                self.homeView.labelINTVideo.isHidden = true
                self.homeView.labelVideo.isHidden = true
                self.homeView.labelINTFollows.isHidden = true
                self.homeView.labelFollows.isHidden = true
                self.homeView.labelINTFolowers.isHidden = true
                self.homeView.labelFolowers.isHidden = true
                self.homeView.labelDescription.isHidden = true
                
               
               case .closed:
                print("close Second")
                self.rightbuttonSubscribeConstant.isActive = false
                self.centerbuttonSubscribeConstant.isActive = false
                self.topbuttonSubscribeConstant.isActive = true
                self.leftbuttonSubscribeConstant.isActive = true

                   self.bottomConstraint.constant = -100
                   self.heightConstant.constant = 90
                   self.widthConstant.constant = 90
                   self.centerConstant.isActive = true
                   self.topConstraint.isActive = true
                   self.leftConstant.isActive = false
                   self.botConstant.isActive = false
                   self.leftWelcomeLabelConstant.isActive = false
                   self.topWelcomLabelConstant.constant = 105
                   self.centerWelcomeLabelConstant.isActive = false
                   self.homeView.welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
                   self.homeView.labelFollow.isHidden = true
                self.homeView.imageLogoProfile.makeRounded()
                self.homeView.buttonFollow.isHidden = false
                self.homeView.buttonInstagram.isHidden = false
                self.homeView.buttonTwiter.isHidden = false
                self.homeView.buttonfaceBook.isHidden = false
                self.homeView.labelINTVideo.isHidden = false
                self.homeView.labelVideo.isHidden = false
                self.homeView.labelINTFollows.isHidden = false
                self.homeView.labelFollows.isHidden = false
                self.homeView.labelINTFolowers.isHidden = false
                self.homeView.labelFolowers.isHidden = false
                self.homeView.labelDescription.isHidden = false
                
                
               }
           }
           transitionAnimator.startAnimation()
       }

    
    func changeButton() {
        AppUtility.lockOrientation(.all)
        homeView.buttonChatUser.isHidden = false
        homeView.buttonChat.isHidden = false

    }
    
    
    var button = UIButton()
    
    func change(to index: Int) {
        if index == 0 {
            homeView.buttonOnline.isHidden = false
            homeView.buttonOffline.isHidden = false
            homeView.buttonComing.isHidden = false
            homeView.imagePromo.isHidden = false
            homeView.labelCategory.isHidden = false
            homeView.labelStreamInfo.isHidden = false
            homeView.labelStreamDescription.isHidden = false
            homeView.tableView.isHidden = true
        }
        if index == 1 {
            homeView.buttonOnline.isHidden = true
            homeView.buttonOffline.isHidden = true
            homeView.buttonComing.isHidden = true
            homeView.imagePromo.isHidden = true
            homeView.labelCategory.isHidden = true
            homeView.labelStreamInfo.isHidden = true
            homeView.labelStreamDescription.isHidden = true
            homeView.tableView.isHidden = false
        }
    }
    func changeBackgroundColor() {
        AppUtility.lockOrientation(.all)
        isLandscape = false
        
        if isLandscape {

        } else {
           
            self.homeView.buttonChatUser.isHidden = false
        }
        if isLand {
            self.button.isHidden = false
        } else {
           // homeView.buttonChat.isHidden = false
        }
    }

    func changeUp(key: CGFloat) {
        print("OLLLL === \(key)")

    }
    func changeDown(key: CGFloat) {
        print("changeDown")

    }
    
    func changeBackground() {
        self.dismiss(animated: true, completion: nil)
    }
    var isPlaying: Bool = false
    var isButton: Bool = true
    
    var isLandscape: Bool = true
    var isLand:Bool = true
    var isPortraiteFull: Bool = false
    var isFullSize = false
    
    var id: Int?
    var follow: String?
    var watch: Int?
    
    let controller =  ChatVCPlayer()

    let homeView = PresentCode()
    var playerViewController: AVPlayerViewController?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    let actionChatTransitionManager = ActionTransishionChatManadger()
   // let actionPresentChat = ActionChatPresentationController()
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeUser: AnyCancellable?
    private var watcherMap: AnyCancellable?
    private var take: AnyCancellable?
    
    @Inject var fitMeetChannels: FitMeetChannels
    private var takeChannels: AnyCancellable?
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var listBroadcast: [BroadcastResponce] = []
    
    var broadcast: BroadcastResponce?
    var  broadId: Int?
    
    private let refreshControl = UIRefreshControl()
   // var  playerContainerView: PlayerContainerView?
  
    var Url: String?
    var playPauseButton: PlayPauseButton!
    var user: User?

    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.homeView.imageLogoProfile.makeRounded()
       // layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeView.imageLogoProfile.makeRounded()
      // layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        homeView.buttonChatUser.isHidden = true
        loadPlayer()
        makeNavItem()
        homeView.imageLogoProfile.makeRounded()
        guard let id = id ,let _ = follow else { return }
        
        bindingUser(id: id)
        guard let  broadId = broadId else { return }
        getMapWather(ids: [broadId])
       

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
       // layout()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        SocketWatcher.sharedInstance.closeConnection()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationItem.largeTitleDisplayMode = .always
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Videos"])//," Timetable"
        homeView.segmentControll.delegate = self
        homeView.segmentControll.backgroundColor = UIColor(hexString: "#F6F6F6")
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        actionButton ()
        self.view.addSubview(self.homeView.viewChat)
        SocketIOManager.sharedInstance.getTokenChat()
        layout()
        homeView.viewTop.addGestureRecognizer(tapRecognizer)
       // homeView.viewTop.addGestureRecognizer(panRecognizer)

        
        _ = UserDefaults.standard.string(forKey: "tokenChat")
        _ = UserDefaults.standard.string(forKey: Constants.broadcastID)
        _ = UserDefaults.standard.string(forKey: Constants.chanellID)
        
        
        homeView.imagePromo.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionBut(sender:))))
        guard let broadcast = broadcast else { return }        
        homeView.labelStreamDescription.text = broadcast.description
        
//        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action:#selector(popupViewTapped(recognizer:)))
//        swipeGestureRecognizerDown.direction = .down
//        homeView.viewTop.addGestureRecognizer(swipeGestureRecognizerDown)
//
////        let UPswipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action:#selector(popupViewTapped(recognizer:)))
//        swipeGestureRecognizerDown.direction = .up
//        homeView.viewTop.addGestureRecognizer(swipeGestureRecognizerDown)

    }
    func actionButton () {
        homeView.buttonLandScape.addTarget(self, action: #selector(rightHandAction), for: .touchUpInside)
        homeView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
        homeView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
        homeView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)
        homeView.buttonChat.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonSubscribe.addTarget(self, action: #selector(actionSubscribe), for: .touchUpInside)
        homeView.buttonChatUser.addTarget(self, action: #selector(actionUserOnline), for: .touchUpInside)
        button.addTarget(self, action: #selector(actionChat), for: .touchUpInside)
        homeView.buttonMore.addTarget(self, action: #selector(actionLike), for: .touchUpInside)
        homeView.buttonLike.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        

    }

    // MARK: - Helper Methods
 
    
//    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
//        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(viewTopPresent))
//        swipeGestureRecognizer.direction = direction
//        return swipeGestureRecognizer
//    }
//    let presenter: Presentr = {
//        let presenter = Presentr(presentationType: .topHalf)
//        return presenter
//    }()
    //MARK: - Selectors
//    @objc func viewTopPresent(_ sender: UISwipeGestureRecognizer) {
//        switch sender.direction {
//        case .up:
//
//         print("U{PPPPP")
//        case .down:
//
//        print("~Down")
//        default:
//            break
//        }
//
//        UIView.animate(withDuration: 0.25) {
//
//
//          //  self.homeView.viewTop.frame = frame
//          //  self.homeView.viewTop.transform = CGAffineTransform(scaleX: x, y: y)
//        }
//        presenter.transitionType = TransitionType.coverVerticalFromTop
//        presenter.transitionType = nil
//        presenter.dismissTransitionType = nil
//        presenter.dismissOnSwipe = true
//        presenter.dismissAnimated = true
//        presenter.roundCorners = true
//
//        let vc = Coach()
//        vc.user = self.user
//        customPresentViewController(presenter, viewController: vc, animated: true)
//
//    }
    @objc func actionOnline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.imagePromo.isHidden = false
        homeView.labelCategory.isHidden = false
        homeView.labelStreamDescription.isHidden = false
        homeView.labelStreamInfo.isHidden = false
        homeView.buttonChat.isHidden = false

    }
    @objc func actionLike() {
        homeView.buttonLike.isSelected.toggle()
        if homeView.buttonLike.isSelected {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "iconlovered"), for: .normal)
        } else {
            homeView.buttonLike.setImage(#imageLiteral(resourceName: "iconlove"), for: .normal)
        }

    }
    @objc func actionMore() {
        let detailViewController = SendCoach()
        actionSheetTransitionManager.height = 0.3
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        present(detailViewController, animated: true)

    }
    @objc func actionSubscribe() {
        homeView.buttonSubscribe.isSelected.toggle()
        
        if homeView.buttonSubscribe.isSelected {
            homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "#3B58A4")
            homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "FFFFFF"), for: .normal)
            let detailViewController = SubscribeVC()

            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionSheetTransitionManager
            
            present(detailViewController, animated: true)
        } else {
            homeView.buttonSubscribe.backgroundColor = UIColor(hexString: "FFFFFF")
            homeView.buttonSubscribe.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        }

    }
    @objc func actionOffline() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#3B58A4")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#BBBCBC")
      
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        homeView.buttonChat.isHidden = true

    }
    @objc func actionComming() {
        homeView.buttonOnline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonOffline.backgroundColor = UIColor(hexString: "#BBBCBC")
        homeView.buttonComing.backgroundColor = UIColor(hexString: "#3B58A4")
     
        homeView.imagePromo.isHidden = true
        homeView.labelCategory.isHidden = true
        homeView.labelStreamDescription.isHidden = true
        homeView.labelStreamInfo.isHidden = true
        homeView.buttonChat.isHidden = true

    }
    @objc func actionBut(sender:UITapGestureRecognizer) {
        
        
        if isButton {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.buttonLandScape.isHidden = true
            playPauseButton.isHidden = true
            homeView.buttonChat.isHidden = true
            homeView.buttonChatUser.isHidden = true
            button.isHidden = true
            isButton = false
        } else {
            button.isHidden = false
            homeView.buttonChat.isHidden = false
            homeView.buttonChatUser.isHidden = false
            if isLand {
                self.button.isHidden = false
            } else {
                self.button.isHidden = true
            }
            
            homeView.overlay.isHidden = false
            homeView.imageLive.isHidden = false
            homeView.labelLive.isHidden = false
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.buttonLandScape.isHidden = false
            playPauseButton.isHidden = false
            isButton = true
        }

    }
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = ""
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        
                    let backButto = UIButton()
                    backButto.setTitle("Back", for: .normal)
                    backButto.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    
                    let backButton = UIButton()
                    backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton,backButto,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
      //  self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
                
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    func setUserProfile(user: User) {
        
        homeView.welcomeLabel.text =  user.fullName
        homeView.setImage(image: user.avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png")
        guard let follow = user.channelFollowCount else { return }
        homeView.labelFollow.text = "Followers:" + "\(follow)"
        self.homeView.welcomeLabel.text = user.fullName
        self.homeView.labelINTFollows.text = "\(user.channelFollowCount!)"
        self.homeView.labelINTFolowers.text = "\(user.channelSubscribeCount!)"
        self.homeView.labelDescription.text = "Welcome to my channel!My name is \(user.fullName!)"
       
    }
    // MARK: - LoadPlayer
    func loadPlayer() {
        guard let url = Url else { return }
                let videoURL = URL(string: url)
                let player = AVPlayer(url: videoURL!)
                self.playerViewController = AVPlayerViewController()
             
        let playerFrame = self.homeView.imagePromo.bounds
        playerViewController!.player = player
        player.rate = 1 
        playerViewController!.view.frame = playerFrame
        playerViewController!.showsPlaybackControls = false
        playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                  
                
        addChild(playerViewController!)
        homeView.imagePromo.addSubview(playerViewController!.view)

        playerViewController!.didMove(toParent: self)

              playPauseButton = PlayPauseButton()
              playPauseButton.avPlayer = player
        
        
              homeView.imagePromo.addSubview(playPauseButton)
        
              view.addSubview(homeView.buttonLandScape)
        rightLandscape = homeView.buttonLandScape.trailingAnchor.constraint(equalTo: homeView.imagePromo.trailingAnchor, constant: -40)
        rightLandscape.isActive = true
        homeView.buttonLandScape.anchor(bottom: homeView.imagePromo.bottomAnchor, paddingBottom: 20,width: 30,height: 30)
            
        
           //   homeView.addSubview(homeView.buttonSetting)
           //   homeView.buttonSetting.anchor( right: homeView.buttonLandScape.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25,width: 30,height: 30)
        
        homeView.addSubview(homeView.buttonChatUser)
        homeView.buttonChatUser.anchor( right: homeView.buttonLandScape.leftAnchor, paddingRight: 5, width: 30, height: 30)
        homeView.buttonChatUser.centerY(inView: homeView.buttonLandScape)
        
             homeView.imagePromo.addSubview(homeView.labelTimer)
             homeView.labelTimer.anchor( left: homeView.imagePromo.leftAnchor, bottom: homeView.imagePromo.bottomAnchor, paddingLeft: 10, paddingBottom: 20)
        
        homeView.imagePromo.addSubview(homeView.overlay)
        
        topOverlayConstant = homeView.overlay.topAnchor.constraint(equalTo: self.homeView.imagePromo.topAnchor, constant: 8)
        topOverlayConstant.isActive = true
        
        homeView.overlay.anchor(
                       left: homeView.imagePromo.leftAnchor,
                       paddingLeft: 16,  width: 90, height: 24)

        homeView.imagePromo.addSubview(homeView.imageLive)
        homeView.imageLive.anchor( left: homeView.overlay.leftAnchor, paddingLeft: 6, width: 12, height: 12)
        homeView.imageLive.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.labelLive)
        homeView.labelLive.anchor( left: homeView.imageLive.rightAnchor, paddingLeft: 6)
        homeView.labelLive.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.imageEye)
        homeView.imageEye.anchor( left: homeView.labelLive.rightAnchor, paddingLeft: 6, width: 12, height: 12)
        homeView.imageEye.centerY(inView: homeView.overlay)
        
        homeView.imagePromo.addSubview(homeView.labelEye)
        homeView.labelEye.anchor( left: homeView.imageEye.rightAnchor, paddingLeft: 6)
        homeView.labelEye.centerY(inView: homeView.overlay)
        
        if isLand {
            //button
        } else {
            
        }
       
        
               let tim : Float64 = CMTimeGetSeconds((player.currentItem?.asset.duration)!)
               print("TIM=====\(tim)")
               playPauseButton.setup(in: self)

    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
        
            playPauseButton.updateUI()
           
        
           if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            isFullSize = true
            homeView.buttonChatUser.isHidden = true
            isLand = true
            button.isHidden = false
            self.view.addSubview(button)
            homeView.viewTop.isHidden = true
            self.homeView.buttonHelpCoach.isHidden = true
            self.homeView.welcomeLabel.isHidden = true
            self.homeView.buttonSubscribe.isHidden = true
            self.homeView.buttonFollow.isHidden = true
            self.homeView.buttonInstagram.isHidden = true
            self.homeView.buttonTwiter.isHidden = true
            self.homeView.buttonfaceBook.isHidden = true
            self.homeView.labelINTVideo.isHidden = true
            self.homeView.labelVideo.isHidden = true
            self.homeView.labelINTFollows.isHidden = true
            self.homeView.labelFollows.isHidden = true
            self.homeView.labelINTFolowers.isHidden = true
            self.homeView.labelFolowers.isHidden = true
            self.homeView.labelDescription.isHidden = true
            self.homeView.labelFollow.isHidden = true
            self.homeView.buttonChat.isHidden = true
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            homeView.imageLogoProfile.isHidden = true
            
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                    self.playerViewController?.view.fillFull(for: self.view)
                    self.topOverlayConstant.constant = 8
                    self.rightLandscape.constant = -80
                    self.homeView.buttonLandScape.anchor( bottom: self.homeView.imagePromo.bottomAnchor,  paddingBottom: 20,width: 45,height: 45)
                
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
//                    self.view.setNeedsLayout()
                    self.homeView.buttonChatUser.isHidden = false
                    self.homeView.addSubview(self.homeView.buttonChatUser)
                    self.homeView.buttonChatUser.anchor(right: self.homeView.buttonLandScape.leftAnchor,
                                                        paddingRight: 5,width: 40, height: 40)

                    self.homeView.buttonChatUser.centerY(inView: self.homeView.buttonLandScape)

                    self.button.isHidden = false
                    self.button.anchor( right: self.homeView.buttonChatUser.leftAnchor, paddingRight: 10, width: 30, height: 30)
                    self.button.centerY(inView: self.homeView.buttonChatUser)
                    self.button.setImage( #imageLiteral(resourceName: "Group1-1"), for: .normal)

                },completion: nil)
  
            isPlaying = true
            isLandscape = true
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
           } else {
               print("Portrait")

            isLand = false
            button.isHidden = true
            self.homeView.buttonChat.isHidden = false

           // self.homeView.buttonLandScape.removeFromSuperview()
           // self.homeView.buttonChat.removeFromSuperview()
            isLandscape = false
            
            
                
            if self.isFullSize {
                    let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                    self.topOverlayConstant.constant = 50
                    self.homeView.labelChat.text = "Comments"
                    self.homeView.labelChat.textColor = .white
                    self.homeView.imageChat.image = #imageLiteral(resourceName: "arrow")
                    self.rightLandscape.constant = -8
//
//
                    self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,
                                                    bottom: self.playerViewController?.view.bottomAnchor,
                                                    paddingLeft: 10, paddingBottom: 20,width: 80, height: 30)
                    self.homeView.buttonChat.centerY(inView: self.homeView.buttonLandScape)
                    self.view.layoutIfNeeded()
                    })
                transitionAnimator.startAnimation()
    } else {
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
                self.homeView.buttonChat.anchor(left:self.view.leftAnchor,
                                                bottom: self.view.bottomAnchor,
                                                 paddingLeft: 10,paddingBottom: 80,width: 80, height: 30)
                self.homeView.labelChat.text = "Comments"
                self.homeView.labelChat.textColor = .black
                self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")
                self.view.layoutIfNeeded()
                })
            transitionAnimator.startAnimation()
            }
            
            

            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {
                    
                   // self.view.setNeedsLayout()
                    
                 //   self.homeView.cardView.addSubview(self.homeView.buttonChat)
                    
                    
                    
                    if self.isPortraiteFull {
  //                      self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,
 //                                                       bottom: self.homeView.imagePromo.bottomAnchor,
 //                                                       paddingLeft: 10,paddingBottom: 20,width: 80, height: 30)
//                        self.homeView.labelChat.text = "Comments"
//                        self.homeView.labelChat.textColor = .white
//                        self.homeView.imageChat.image = #imageLiteral(resourceName: "arrow")
                    } else if self.isPortraiteFull == false {
                        
//                        self.homeView.buttonChat.anchor(left:self.homeView.cardView.leftAnchor,
//                                                        bottom: self.homeView.cardView.bottomAnchor,
//                                                        paddingLeft: 10,paddingBottom: 20,width: 80, height: 30)
//                        self.homeView.labelChat.text = "Comments"
//                        self.homeView.labelChat.textColor = .black
//                        self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")
                    }
                    
                                       
//                    self.homeView.buttonChat.addSubview(self.homeView.imageChat)
//                    self.homeView.imageChat.anchor(left: self.homeView.buttonChat.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
//                    self.homeView.imageChat.centerY(inView: self.homeView.buttonChat)
       
//                    self.homeView.imagePromo.addSubview(self.homeView.buttonLandScape)
//                    self.homeView.buttonLandScape.anchor( right: self.homeView.imagePromo.rightAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 24, paddingBottom: 20,width: 45,height: 45)
                    
//                    self.homeView.imagePromo.addSubview(self.homeView.buttonSetting)
//                    self.homeView.buttonSetting.anchor( right: self.homeView.buttonLandScape.leftAnchor, bottom: self.homeView.imagePromo.bottomAnchor, paddingRight: 5, paddingBottom: 25 ,width: 30,height: 30)
//
//                    self.view.setNeedsLayout()

                },completion: nil)
            self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill

           }
       }
    // MARK: - ButtonLandscape
    @objc func rightHandAction() {
        
           
       
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
               
                    self.topOverlayConstant.constant = 8
            
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            self.view.layoutIfNeeded()
        

        self.playerViewController!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if isPlaying {
            isFullSize = false
            print("FulSize === \(isFullSize)")
            isPlaying = false
            isPortraiteFull = false
            let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
               
                    self.topOverlayConstant.constant = 8
            
                self.view.layoutIfNeeded()
            
            })
            transitionAnimator.startAnimation()
            self.view.layoutIfNeeded()
           
            navigationController?.navigationBar.isHidden = false
            tabBarController?.tabBar.isHidden = false
            self.homeView.imageLogoProfile.isHidden = false
            self.homeView.buttonSubscribe.isHidden = false
            self.homeView.segmentControll.isHidden = false
            self.homeView.buttonComing.isHidden = false
            self.homeView.buttonOnline.isHidden = false
            self.homeView.buttonOffline.isHidden = false
            self.homeView.labelFollow.isHidden = false
            self.homeView.buttonHelpCoach.isHidden = false
    
            self.homeView.viewTop.isHidden = false
            self.homeView.imagePromo.removeFromSuperview()
            self.homeView.labelCategory.removeFromSuperview()
            self.homeView.labelStreamInfo.removeFromSuperview()
            self.homeView.labelStreamDescription.removeFromSuperview()
            self.homeView.buttonChat.removeFromSuperview()
            self.homeView.buttonChatUser.removeFromSuperview()
            self.homeView.imageChat.removeFromSuperview()
            self.homeView.labelChat.removeFromSuperview()
            self.homeView.labelChat.textColor = .black
            self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")
            self.homeView.viewTop.removeFromSuperview()
            self.homeView.imageLogoProfile.removeFromSuperview()
            self.homeView.welcomeLabel.removeFromSuperview()
            self.homeView.welcomeLabel.isHidden = false
            self.homeView.labelFollow.removeFromSuperview()
            self.homeView.buttonLandScape.removeFromSuperview()
            self.homeView.buttonMore.removeFromSuperview()
            self.homeView.buttonLike.removeFromSuperview()
            self.homeView.buttonChat.isHidden = false
            UIView.animate(withDuration: 1.0,
                delay: 0.0,
                options: [],
                animations: {

                    self.homeView.cardView.addSubview(self.homeView.imagePromo)
                    self.homeView.imagePromo.anchor(top: self.homeView.buttonComing.bottomAnchor,
                                                  left: self.homeView.cardView.leftAnchor,
                                                  right: self.homeView.cardView.rightAnchor,
                                                  paddingTop: 15, paddingLeft: 0, paddingRight: 0, height: 208)

                    self.view.addSubview(self.homeView.buttonLandScape)
                    self.rightLandscape = self.homeView.buttonLandScape.trailingAnchor.constraint(equalTo: self.homeView.imagePromo.trailingAnchor, constant: -20)
                    self.rightLandscape.isActive = true
                    self.homeView.buttonLandScape.anchor(bottom: self.homeView.imagePromo.bottomAnchor, paddingBottom: 20,width: 40,height: 40)

                    self.homeView.cardView.addSubview(self.homeView.labelCategory)
                    self.homeView.labelCategory.anchor(top: self.homeView.imagePromo.bottomAnchor,
                                         left: self.homeView.cardView.leftAnchor, paddingTop: 11, paddingLeft: 16)

                    self.homeView.cardView.addSubview(self.homeView.labelStreamInfo)
                    self.homeView.labelStreamInfo.anchor(top: self.homeView.labelCategory.bottomAnchor,
                                                         left: self.homeView.cardView.leftAnchor,
                                           paddingTop: 9, paddingLeft: 16)

                    self.homeView.cardView.addSubview(self.homeView.labelStreamDescription)
                    self.homeView.labelStreamDescription.anchor(top: self.homeView.labelStreamInfo.bottomAnchor,
                                                                left: self.homeView.cardView.leftAnchor,
                                                                right: self.homeView.cardView.rightAnchor,
                                                  paddingTop: 4, paddingLeft: 16, paddingRight: 16)
                    
                    self.homeView.cardView.addSubview(self.homeView.buttonMore)
                    self.homeView.buttonMore.anchor(top: self.homeView.imagePromo.bottomAnchor,right: self.homeView.cardView.rightAnchor, paddingTop: 11, paddingRight: 20, width: 30, height: 30)
                    
                    self.homeView.cardView.addSubview(self.homeView.buttonLike)
                    self.homeView.buttonLike.anchor(top: self.homeView.imagePromo.bottomAnchor,right: self.homeView.buttonMore.leftAnchor, paddingTop: 11, paddingRight: 10, width: 30, height: 30)
                    
                    self.homeView.cardView.addSubview(self.homeView.buttonChat)
                    self.homeView.buttonChat.anchor(left:self.view.leftAnchor,bottom: self.view.bottomAnchor, paddingLeft: 15,paddingBottom: 80,width: 80, height: 30)
               
                    self.homeView.labelChat.text = "Comments"
                    self.homeView.labelChat.textColor = .black
                    self.homeView.imageChat.image = #imageLiteral(resourceName: "icons8-expand-arrow-100")

                    self.homeView.buttonChat.addSubview(self.homeView.imageChat)

                    self.homeView.imageChat.anchor(left: self.homeView.buttonChat.leftAnchor,  paddingLeft: 10,width: 15,height: 15)
                    self.homeView.imageChat.centerY(inView: self.homeView.buttonChat)

                    self.homeView.buttonChat.addSubview(self.homeView.labelChat)
                    self.homeView.labelChat.anchor( left: self.homeView.imageChat.rightAnchor, paddingLeft: 10)
                    self.homeView.labelChat.centerY(inView: self.homeView.buttonChat)
                    
                    self.setConstranteTopView()
                         
                  
                    AppUtility.lockOrientation(.all, andRotateTo: .portrait)
                    self.isPortraiteFull = false
                    self.view.layoutIfNeeded()
                },completion: nil)
        } else {
            
            isFullSize = true
            isPortraiteFull = true
            AppUtility.lockOrientation(.all, andRotateTo: .landscapeLeft)
            print("ALL EXIT")
        }
    }
   
    @objc func leftHandAction() {
    
        print("left bar button action")
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
       }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - UserOnline
    @objc func actionUserOnline () {
        homeView.overlay.isHidden = true
        homeView.imageLive.isHidden = true
        homeView.labelLive.isHidden = true
        homeView.imageEye.isHidden = true
        homeView.labelEye.isHidden = true
       // homeView.buttonSetting.isHidden = true
        homeView.buttonLandScape.isHidden = true
        playPauseButton.isHidden = true
        isButton = false
        homeView.buttonChat.isHidden = true
        homeView.buttonChatUser.isHidden = true

        let chatVC = UserVC()
        guard let id = broadcast?.id,let channel = broadcast?.channelIds?.first  else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = "\(channel)"
        chatVC.delegate = self
        
        chatVC.transitioningDelegate = actionChatTransitionManager
        chatVC.modalPresentationStyle = .custom
        if isLand {
            button.isHidden = true
            actionChatTransitionManager.intWidth = 0.5
            actionChatTransitionManager.intHeight = 1
            present(chatVC, animated: true, completion: nil)
        } else {
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            actionChatTransitionManager.isLandscape = isLandscape
            present(chatVC, animated: true)
        }
    }
    
    
    // MARK: - ActionChat
    @objc func actionChat(sender:UITapGestureRecognizer) {
        self.button.isHidden = true
        self.homeView.buttonChatUser.isHidden = true
        if isPlaying {
            homeView.overlay.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
           // homeView.buttonSetting.isHidden = true
            homeView.buttonLandScape.isHidden = true
            playPauseButton.isHidden = true
            isButton = false
            homeView.buttonChat.isHidden = true
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
            detailViewController.color = .clear

            if isLand {
                actionChatTransitionManager.intWidth = 0.5
                actionChatTransitionManager.intHeight = 1
                actionChatTransitionManager.isLandscape = isLand
               // detailViewController.chatView.buttonChat.isHidden = true
                detailViewController.chatView.buttonComm.isHidden = true
                detailViewController.chatView.buttonCloseChat.isHidden = false
                present(detailViewController, animated: true)
                //transitionVc(vc: detailViewController, duration: 0.5, type: .fromRight)
            } else {
                actionChatTransitionManager.intWidth = 1
                actionChatTransitionManager.intHeight = 0.7
                actionChatTransitionManager.isLandscape = isLand
               // detailViewController.chatView.buttonChat.isHidden = false
                detailViewController.chatView.buttonComm.isHidden = false
                detailViewController.chatView.buttonCloseChat.isHidden = true
                present(detailViewController, animated: true)
            }
            
        } else {
            AppUtility.lockOrientation(.portrait)
            
            let detailViewController = ChatVCPlayer()
            detailViewController.modalPresentationStyle = .custom
            detailViewController.transitioningDelegate = actionChatTransitionManager
            detailViewController.broadcast = broadcast
            detailViewController.delegate = self
            detailViewController.color = .white
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            present(detailViewController, animated: true)
        }
       
    }
    
 // MARK: - NetworkMetod
    func followChannels(id: Int) {
        takeChannels = fitMeetChannels.followChannels(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.subscribersCount != nil  {
                   print(response)
                }
            })
      }

    func bindingUser(id: Int) {
        takeUser = fitMeetApi.getUserId(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                        self.user = response
                        self.setUserProfile(user: self.user!)
                }
            })
        }
    
    
    
    func getMapWather(ids: [Int])  {
        watcherMap = fitMeetApi.getWatcherMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                   // print("WATCHERPresent======\(response.data["\(ids.first!)"]!)")
                    guard let watchers = response.data["\(ids.first!)"] else { return }
                   // self.loadPlayer()
                    self.homeView.labelEye.text = "\(watchers)"
                   // print("WATCH RETURN = \(self.watch)")
                        
                }
            })
       }
    
    private func setConstranteTopView() {
        
        self.homeView.viewTop.translatesAutoresizingMaskIntoConstraints = false
        self.homeView.imageLogoProfile.translatesAutoresizingMaskIntoConstraints = false
        self.homeView.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.homeView.labelFollow.translatesAutoresizingMaskIntoConstraints = false
       
       // self.homeView.cardView.addSubview(self.homeView.viewTop)
        self.homeView.viewTop.addSubview(self.homeView.imageLogoProfile)
        
        self.view.addSubview(self.homeView.viewTop)
       // self.view.addSubview(self.homeView.imageLogoProfile)
        
        self.view.addSubview(self.homeView.welcomeLabel)
        self.view.addSubview(self.homeView.labelFollow)
        self.homeView.viewTop.addSubview(homeView.buttonSubscribe)
        view.addSubview(homeView.buttonFollow)
        view.addSubview(homeView.buttonInstagram)
        view.addSubview(homeView.buttonTwiter)
        view.addSubview(homeView.buttonfaceBook)
        view.addSubview(homeView.labelINTVideo)
        view.addSubview(homeView.labelVideo)
        view.addSubview(homeView.labelINTFollows)
        view.addSubview(homeView.labelFollows)
        view.addSubview(homeView.labelINTFolowers)
        view.addSubview(homeView.labelFolowers)
        view.addSubview(homeView.labelDescription)
        
       // self.homeView.buttonSubscribe.isHidden = true
        self.homeView.buttonFollow.isHidden = true
        self.homeView.buttonInstagram.isHidden = true
        self.homeView.buttonTwiter.isHidden = true
        self.homeView.buttonfaceBook.isHidden = true
        self.homeView.labelINTVideo.isHidden = true
        self.homeView.labelVideo.isHidden = true
        self.homeView.labelINTFollows.isHidden = true
        self.homeView.labelFollows.isHidden = true
        self.homeView.labelINTFolowers.isHidden = true
        self.homeView.labelFolowers.isHidden = true
        self.homeView.labelDescription.isHidden = true
       
        self.homeView.viewTop.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.homeView.viewTop.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        if isPortraiteFull {
            self.bottomConstraint = self.homeView.viewTop.topAnchor.constraint(equalTo:self.homeView.cardView.topAnchor, constant: -400)
        }
       
        self.bottomConstraint.isActive = true
        self.homeView.viewTop.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        
        

        homeView.labelFollow.bottomAnchor.constraint(equalTo: homeView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
        homeView.labelFollow.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 12).isActive = true
        

        topWelcomLabelConstant = homeView.welcomeLabel.topAnchor.constraint(equalTo: homeView.imageLogoProfile.topAnchor, constant: 0)
        topWelcomLabelConstant.isActive = true
        
        leftWelcomeLabelConstant = homeView.welcomeLabel.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 15)
        leftWelcomeLabelConstant.isActive = true
        
        centerWelcomeLabelConstant = homeView.welcomeLabel.centerXAnchor.constraint(equalTo: homeView.cardView.centerXAnchor)
        centerWelcomeLabelConstant.isActive = false
        

        leftConstant = homeView.imageLogoProfile.leadingAnchor.constraint(equalTo: homeView.viewTop.leadingAnchor, constant: 20)
        leftConstant.isActive = true
        
        
        botConstant = homeView.imageLogoProfile.bottomAnchor.constraint(equalTo: homeView.viewTop.bottomAnchor, constant: -20)
        botConstant.isActive = true
        
        topConstraint = homeView.imageLogoProfile.topAnchor.constraint(equalTo: homeView.cardView.topAnchor, constant: 20)
        topConstraint.isActive = false
        
        centerConstant = homeView.imageLogoProfile.centerXAnchor.constraint(equalTo: homeView.cardView.centerXAnchor)
        centerConstant.isActive = false
        
        heightConstant = homeView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
        heightConstant.isActive = true
        widthConstant = homeView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
        widthConstant.isActive = true
       
        topbuttonSubscribeConstant = homeView.buttonSubscribe.topAnchor.constraint(equalTo: homeView.welcomeLabel.bottomAnchor, constant: 20)
        topbuttonSubscribeConstant.isActive = false
        leftbuttonSubscribeConstant = homeView.buttonSubscribe.leadingAnchor.constraint(equalTo: homeView.viewTop.leadingAnchor, constant: 18)
        leftbuttonSubscribeConstant.isActive = false
        rightbuttonSubscribeConstant = homeView.buttonSubscribe.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -10)
        rightbuttonSubscribeConstant.isActive = true
        centerbuttonSubscribeConstant = homeView.buttonSubscribe.centerYAnchor.constraint(equalTo: homeView.imageLogoProfile.centerYAnchor)
        centerbuttonSubscribeConstant.isActive = true
        
        
        homeView.buttonSubscribe.anchor( width: 100, height: 28)
        
        homeView.buttonFollow.anchor(top: homeView.welcomeLabel.bottomAnchor, paddingTop: 20, width: 102, height: 28)
        homeView.buttonFollow.centerX(inView: homeView.viewTop)
 
       
        homeView.buttonInstagram.anchor(  right: homeView.cardView.rightAnchor,paddingRight: 17, width: 28, height: 28)
        homeView.buttonInstagram.centerY(inView: homeView.buttonSubscribe)
        
        
        
        homeView.buttonTwiter.anchor(right: homeView.buttonInstagram.leftAnchor,paddingRight: 8,  width: 28, height: 28)
        homeView.buttonTwiter.centerY(inView: homeView.buttonInstagram)

        
        homeView.buttonfaceBook.anchor( right: homeView.buttonTwiter.leftAnchor, paddingRight: 8, width: 28, height: 28)
        homeView.buttonfaceBook.centerY(inView: homeView.buttonInstagram)
        
        
        homeView.labelINTVideo.anchor(top: homeView.buttonSubscribe.bottomAnchor, left: homeView.viewTop.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
        
        homeView.labelVideo.anchor(top: homeView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelVideo.centerX(inView: homeView.labelINTVideo)
        
        
        
        homeView.labelINTFollows.anchor(top: homeView.buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
        homeView.labelINTFollows.centerX(inView: homeView.buttonFollow)
        
        
        homeView.labelFollows.anchor(top: homeView.labelINTFollows.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelFollows.centerX(inView: homeView.viewTop)
        
        
        
        
        homeView.labelINTFolowers.anchor(top: homeView.buttonSubscribe.bottomAnchor, right: homeView.viewTop.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
        
        homeView.labelFolowers.anchor(top: homeView.labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        homeView.labelFolowers.centerX(inView: homeView.labelINTFolowers)
        
        
        homeView.labelDescription.anchor(top: homeView.labelFollows.bottomAnchor, left: homeView.viewTop.leftAnchor, right: homeView.viewTop.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
        
        homeView.buttonHelpCoach.anchor(bottom:homeView.viewTop.bottomAnchor,paddingBottom: -5,width: 40, height: 30)
        homeView.buttonHelpCoach.centerX(inView: homeView.viewTop)
        
    }
    
}

// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
