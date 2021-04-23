//
//  MainTabViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit
import AVFoundation
import Photos

class StreamingVC: UIViewController {
    let streamView = StreamingVCCode()
    
    override func loadView() {
        super.loadView()
        view = streamView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
    }
    
    func actionButton() {
        streamView.videoModeButton.addTarget(self, action: #selector(nextView), for: .touchUpInside)
    }
    
    @objc func nextView() {
        let signUpVC = LiveStreamVC()
        signUpVC.preset = LiveStreamVC.Preset.sd_540p_30fps_2mbps
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    
    
    
    
}
//extension StreamingVC {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        func configureCameraController() {
//            cameraController.prepare {(error) in
//                if let error = error {
//                    print(error)
//                }
//
//                try? self.cameraController.displayPreview(on: self.streamView.capturePreviewView)
//            }
//        }
//
//        func styleCaptureButton() {
//            streamView.captureButton.layer.borderColor = UIColor.black.cgColor
//            streamView.captureButton.layer.borderWidth = 2
//
//            streamView.captureButton.layer.cornerRadius = min(streamView.captureButton.frame.width, streamView.captureButton.frame.height) / 2
//        }
//
//        styleCaptureButton()
//        configureCameraController()
//
//    }
//}
//
//extension StreamingVC {
//    @IBAction func toggleFlash(_ sender: UIButton) {
//        if cameraController.flashMode == .on {
//            cameraController.flashMode = .off
//            streamView.toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
//        }
//
//        else {
//            cameraController.flashMode = .on
//            streamView.toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
//        }
//    }
//
//    @IBAction func switchCameras(_ sender: UIButton) {
//        do {
//            try cameraController.switchCameras()
//        }
//
//        catch {
//            print(error)
//        }
//
//        switch cameraController.currentCameraPosition {
//        case .some(.front):
//            streamView.toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
//
//        case .some(.rear):
//            streamView.toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
//
//        case .none:
//            return
//        }
//    }
//
//    @IBAction func captureImage(_ sender: UIButton) {
//        cameraController.captureImage {(image, error) in
//            guard let image = image else {
//                print(error ?? "Image capture error")
//                return
//            }
//
//            try? PHPhotoLibrary.shared().performChangesAndWait {
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }
//        }
//    }
//
//}
//
