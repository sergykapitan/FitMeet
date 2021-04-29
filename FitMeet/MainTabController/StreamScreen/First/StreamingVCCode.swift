//
//  StreamingVCCode.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit

final class StreamingVCCode: UIView {
    
    //MARK: - UI
    let capturePreviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
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
        button.setTitle("Create Stream", for: .normal)
        return button
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
        capturePreviewView.addSubview(videoModeButton)
        videoModeButton.anchor( bottom:capturePreviewView.bottomAnchor, paddingBottom: 40,width: 150, height: 50)
        videoModeButton.centerX(inView: capturePreviewView)
         
    }
}
