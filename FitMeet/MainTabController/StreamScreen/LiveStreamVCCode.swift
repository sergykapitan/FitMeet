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
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    let cameraModeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        return button
    }()
    let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        return button
    }()
    let chatButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Message"), for: .normal)
        return button
    }()
    let StartStreamButton: HueButton = {
        let button = HueButton()
        button.layer.cornerRadius = 6
        button.setTitle("Start Live Stream", for: .normal)
        return button
    }()
    var previewView: MTHKView = {
        let view = MTHKView(frame: .zero)
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
                        paddingTop: 60,height: 40)
        labelFPS.centerX(inView: previewView)
                
    capturePreviewView.addSubview(StartStreamButton)
        StartStreamButton.anchor( left:capturePreviewView.leftAnchor,
                                bottom:capturePreviewView.bottomAnchor,
                                paddingLeft: 16,
                                paddingBottom: 32, height: 40)
        StartStreamButton.centerX(inView: capturePreviewView)
        
    capturePreviewView.addSubview(cameraModeButton)
        cameraModeButton.anchor(right: capturePreviewView.rightAnchor,
                                paddingRight: 22)
        cameraModeButton.centerY(inView: StartStreamButton)
        
        
        
        
    }
}
