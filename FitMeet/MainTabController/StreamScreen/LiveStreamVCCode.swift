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
        
        return view
    }()
    let buttonStartStream: UIButton = {
        let button = UIButton()
        button.setTitle("StartStream", for: .normal)
        return button
    }()
    let labelSignUp: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()

    let captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Capthure", for: .normal)
        return button
    }()
    let photoModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("PhotoMode", for: .normal)
        return button
    }()
    let toggleCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Toggle", for: .normal)
        return button
    }()
    let toggleFlashButton: UIButton = {
        let button = UIButton()
        button.setTitle("Flash", for: .normal)
        return button
    }()
    let videoModeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("NextView", for: .normal)
        return button
    }()
    var previewView: MTHKView = {
        let view = MTHKView(frame: .zero)
        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
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
        capturePreviewView.fillSuperview()
        capturePreviewView.addSubview(previewView)
        previewView.anchor(top: capturePreviewView.topAnchor, left: capturePreviewView.leftAnchor, right: capturePreviewView.rightAnchor, bottom: capturePreviewView.bottomAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30, paddingBottom: 30)
        
        
        
        
        
        
        capturePreviewView.addSubview(labelSignUp)
        
        
        
        labelSignUp.anchor(top: capturePreviewView.topAnchor,
                           paddingTop: 46, height: 40)
        labelSignUp.centerX(inView: capturePreviewView)
        capturePreviewView.addSubview(toggleFlashButton)
        toggleFlashButton.anchor(top: capturePreviewView.topAnchor, right: capturePreviewView.rightAnchor,paddingTop: 40,  paddingRight: 40)
        capturePreviewView.addSubview(toggleCameraButton)
        toggleCameraButton.anchor(top: capturePreviewView.topAnchor, right: capturePreviewView.rightAnchor,paddingTop: 80,  paddingRight: 40)
        capturePreviewView.addSubview(photoModeButton)
        photoModeButton.anchor(left: capturePreviewView.leftAnchor, bottom:capturePreviewView.bottomAnchor,paddingRight: 40, paddingBottom: 80)
        
        capturePreviewView.addSubview(videoModeButton)
        videoModeButton.anchor( bottom:capturePreviewView.bottomAnchor, paddingBottom: 40,width: 50, height: 50)
        videoModeButton.centerX(inView: capturePreviewView)
        
        capturePreviewView.addSubview(captureButton)
        captureButton.centerX(inView: capturePreviewView)
        captureButton.anchor( width: 50, height: 50)

        
        
    }
}
