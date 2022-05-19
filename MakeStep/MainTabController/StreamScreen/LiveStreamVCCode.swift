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
    var buttonStart: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blueColor
        button.setTitle("START STREAM", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 14
        button.anchor(width: 137,height: 28)
        return button
    }()
    var buttonAvailable: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#4C4C4C")
        button.setImage(UIImage(named: "All"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 23
        button.anchor(width: 46,height: 46)
        return button
    }()
    var labelAviable: UILabel = {
        let label = UILabel()
        label.text = "Available for all"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10.2)
        return label
    }()
    var buttonStartNow: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#4C4C4C")
        button.setImage(UIImage(named: "startNow"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 23
        button.anchor(width: 46,height: 46)
        return button
    }()
    var labelStartNow: UILabel = {
        let label = UILabel()
        label.text = "Start now"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10.2)
        return label
    }()
    var buttonSetting: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor(hexString: "#4C4C4C")
        button.setImage(UIImage(named: "Settings"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 23
        button.anchor(width: 46,height: 46)
        return button
    }()
    var labelSetting: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10.2)
        return label
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
        
       
        
       
        
        capturePreviewView.addSubview(buttonStart)
        buttonStart.centerX(inView: capturePreviewView)
        buttonStart.anchor( bottom: capturePreviewView.bottomAnchor,paddingBottom: 43)
        
        capturePreviewView.addSubview(buttonAvailable)
        buttonAvailable.centerX(inView: capturePreviewView)
        buttonAvailable.anchor( bottom: buttonStart.topAnchor,paddingBottom: 58)
        
        capturePreviewView.addSubview(labelAviable)
        labelAviable.centerX(inView: buttonAvailable)
        labelAviable.anchor(top: buttonAvailable.bottomAnchor, paddingTop: 4)
        
        capturePreviewView.addSubview(buttonStartNow)
        buttonStartNow.centerY(inView: buttonAvailable)
        buttonStartNow.anchor( right: buttonAvailable.leftAnchor, paddingRight: 42)
        
        capturePreviewView.addSubview(labelStartNow)
        labelStartNow.centerX(inView: buttonStartNow)
        labelStartNow.anchor(top: buttonAvailable.bottomAnchor, paddingTop: 4)
        
        capturePreviewView.addSubview(buttonSetting)
        buttonSetting.centerY(inView: buttonAvailable)
        buttonSetting.anchor( left: buttonAvailable.rightAnchor, paddingLeft: 42)
        
        capturePreviewView.addSubview(labelSetting)
        labelSetting.centerX(inView: buttonSetting)
        labelSetting.anchor(top: buttonSetting.bottomAnchor, paddingTop: 4)
        
        capturePreviewView.addSubview(textFieldNameStream)
        textFieldNameStream.centerX(inView: capturePreviewView)
        textFieldNameStream.anchor( bottom: buttonAvailable.topAnchor ,paddingBottom: 32)
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
