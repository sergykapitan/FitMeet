//
//  LiveStreamVCCode.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import UIKit
import HaishinKit

final class LiveStreamVCCode: UIView {
    
    //MARK: - UI
    let capturePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    let labelFPS: UILabel = {
        let label = UILabel()
        label.text = "FPS"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let cameraModeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "rotate"), for: .normal)
        return button
    }()
    let microfoneButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "microfone"), for: .normal)
        return button
    }()
    let chatButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        return button
    }()
    let StartStreamButton: UIButton = {
        let button = UIButton()
       // button.layer.cornerRadius = 6
        button.setImage(#imageLiteral(resourceName: "startCamera"), for: .normal)
        return button
    }()
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        return button
    }()
    var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    var previewView: MTHKView = {
        let view = MTHKView(frame: .zero)
       return view
    }()
    let recButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "rec"), for: .normal)
        return button
    }()
    let usrButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "user"), for: .normal)
        return button
    }()
    let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "stopStream"), for: .normal)
        return button
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        initUI()
        initLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initUI() {
        addSubview(capturePreviewView)
 
    }
    private func initLayout() {
     
    capturePreviewView.heightAnchor.constraint(equalTo: capturePreviewView.superview!.heightAnchor).isActive = true
    capturePreviewView.widthAnchor.constraint(equalTo: capturePreviewView.superview!.widthAnchor).isActive = true
    capturePreviewView.centerXAnchor.constraint(equalTo: capturePreviewView.superview!.centerXAnchor).isActive = true
    capturePreviewView.centerYAnchor.constraint(equalTo: capturePreviewView.superview!.centerYAnchor).isActive = true
    capturePreviewView.addSubview(previewView)

    previewView.anchor(top: capturePreviewView.topAnchor,
                       left: capturePreviewView.leftAnchor,
                       right: capturePreviewView.rightAnchor,
                       bottom: capturePreviewView.bottomAnchor,
                       paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom:  0)

    capturePreviewView.addSubview(labelFPS)
    labelFPS.anchor(top: capturePreviewView.topAnchor,
                    left: capturePreviewView.leftAnchor,
                    paddingTop: 45,paddingLeft: 15,height: 40)
        
    capturePreviewView.addSubview(timerLabel)
    timerLabel.centerY(inView: labelFPS)
    timerLabel.anchor(top: capturePreviewView.topAnchor,
                        paddingTop: 45)
    timerLabel.centerX(inView: capturePreviewView)
        
    capturePreviewView.addSubview(usrButton)
    usrButton.anchor( right: capturePreviewView.rightAnchor,
                      paddingRight: 24, width: 24, height: 24)
    usrButton.centerY(inView: labelFPS)
        
    capturePreviewView.addSubview(recButton)
    recButton.anchor(right: timerLabel.leftAnchor,
                     paddingRight: 5,  width: 12, height: 12)
    recButton.centerY(inView: timerLabel)
                
    capturePreviewView.addSubview(StartStreamButton)
    StartStreamButton.anchor(  bottom:capturePreviewView.bottomAnchor,
                                paddingBottom: 32)
    StartStreamButton.centerX(inView: capturePreviewView)
     
    capturePreviewView.addSubview(stopButton)
    stopButton.anchor(right: StartStreamButton.leftAnchor,
                                       paddingRight: 15)
    stopButton.centerY(inView: StartStreamButton)
        
        
    capturePreviewView.addSubview(chatButton)
        chatButton.anchor(left: StartStreamButton.rightAnchor,
                                  paddingLeft: 15)
        chatButton.centerY(inView: StartStreamButton)
        
        
    capturePreviewView.addSubview(cameraButton)
    cameraButton.anchor(right: StartStreamButton.leftAnchor,
                                   paddingRight: 15)
    cameraButton.centerY(inView: StartStreamButton)
     
        
    capturePreviewView.addSubview(cameraModeButton)
    cameraModeButton.anchor(right: cameraButton.leftAnchor,
                                paddingRight: 15)
    cameraModeButton.centerY(inView: StartStreamButton)
        
    
    capturePreviewView.addSubview(microfoneButton)
    microfoneButton.anchor(left: chatButton.rightAnchor,
                                 paddingLeft: 15)
    microfoneButton.centerY(inView: StartStreamButton)
        
        
        
   
        
   
    }
}
