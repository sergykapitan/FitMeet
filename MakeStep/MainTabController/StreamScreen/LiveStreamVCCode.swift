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
    let privateStream: UIButton = {
           let button = UIButton()
           button.setImage(#imageLiteral(resourceName: "PrivateStream"), for: .normal)
           return button
    }()
    var stackButton: UIStackView = {
           let stack = UIStackView()
           stack.axis = .horizontal
           stack.distribution = .fillEqually
           return stack
    }()
    
    let close: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "bigClose"), for: .normal)
        return button
    }()
    let textFieldNameStream: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.attributedPlaceholder =
        NSAttributedString(string: "TITLE OF THE STREAM", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.setLeftPaddingPoints(10)
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.textColor = .white
        return textField
    }()
    let lineBottom: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
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
        stackButton = UIStackView(arrangedSubviews: [cameraModeButton,cameraButton,StartStreamButton,chatButton,microfoneButton])
        stackButton.spacing = 10
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
        
        capturePreviewView.addSubview(close)
        close.anchor(top: capturePreviewView.topAnchor,
                        left: capturePreviewView.leftAnchor,
                        paddingTop: 45,paddingLeft: 35,height: 40)
        
        capturePreviewView.addSubview(textFieldNameStream)
        textFieldNameStream.centerX(inView: capturePreviewView)
        textFieldNameStream.centerY(inView: capturePreviewView)
        
        capturePreviewView.addSubview(lineBottom)
        lineBottom.centerX(inView: capturePreviewView)
        lineBottom.anchor( left: textFieldNameStream.leftAnchor,
                           right: textFieldNameStream.rightAnchor,
                           bottom: textFieldNameStream.bottomAnchor,paddingLeft: 0, paddingRight: -10, paddingBottom: 0, height: 1)
        
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
        
        
    capturePreviewView.addSubview(stackButton)
    stackButton.anchor( bottom: capturePreviewView.bottomAnchor, paddingBottom: 32)
    stackButton.centerX(inView: capturePreviewView)
  
   
    }
}
