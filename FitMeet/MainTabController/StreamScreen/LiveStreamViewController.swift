//
//  LiveStreamViewController.swift
//  FitMeet
//
//  Created by novotorica on 29.04.2021.
//

import UIKit
import AVFoundation
import HaishinKit
import Photos
import VideoToolbox
import Foundation

class LiveStreamViewController: UITabBarController {
    
    let streamView = LiveStreamVCCode()
    @Inject var fitMeetStream: FitMeetStream
    private static let maxRetryCount: Int = 5
    var url: String?
    var myuri: String = ""
    var myPublish: String = ""
    
    //UserDefaults.standard.string(forKey: Constants.urlStream)
    
    private var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var sharedObject: RTMPSharedObject!
    private var currentEffect: VideoEffect?
    private var currentPosition: AVCaptureDevice.Position = .back
    private var retryCount: Int = 0
    
    override func loadView() {
        super.loadView()
        view = streamView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        rtmpStream = RTMPStream(connection: rtmpConnection)
        if let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) {
            rtmpStream.orientation = orientation
        }
        rtmpStream.captureSettings = [
            .sessionPreset: AVCaptureSession.Preset.hd1280x720,
            .continuousAutofocus: true,
            .continuousExposure: true
            // .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
        ]
        rtmpStream.videoSettings = [
            .width: 720,
            .height: 1280
        ]
        rtmpStream.mixer.recorder.delegate = ExampleRecorderDelegate.shared
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        view.addGestureRecognizer(tap)
       // videoBitrateSlider?.value = Float(RTMPStream.defaultVideoBitrate) / 1000
       // audioBitrateSlider?.value = Float(RTMPStream.defaultAudioBitrate) / 1000
        let urls = UserDefaults.standard.string(forKey: Constants.urlStream)
        print("URL =============\(urls)")
       // var fullName = "First Last"
       // let fullNameArr = urls.componentsSeparatedByString("/")
        let fullNameArr = urls?.components(separatedBy: "/")
        print(fullNameArr)
        if let str = fullNameArr {
        myuri = str[0] + "//" + str[2] + "/" + str[3]
        myPublish = str[4]
            print("myuri ========\(myuri)\n ffffffff=====\(myPublish)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        logger.info("viewWillAppear")
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            logger.warn(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            logger.warn(error.description)
        }
       // streamView.previewView
        streamView.previewView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
        streamView.previewView.attachStream(rtmpStream)
    }
    override func viewWillDisappear(_ animated: Bool) {
        logger.info("viewWillDisappear")
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        rtmpStream.close()
        rtmpStream.dispose()
    }

    func actionButton() {
        streamView.photoModeButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        streamView.videoModeButton.addTarget(self, action: #selector(startStream), for: .touchUpInside)
    }
    @objc func rotateCamera() {
        logger.info("rotateCamera")
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.captureSettings[.isVideoMirrored] = position == .front
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            logger.warn(error.description)
        }
        currentPosition = position
    }
    @objc func startStream() {
        if streamView.videoModeButton.isSelected {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            streamView.videoModeButton.setTitle("●", for: [])
        } else {
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            rtmpConnection.connect(Preference.defaultInstance.uri!)
            streamView.videoModeButton.setTitle("■", for: [])
        }
        streamView.videoModeButton.isSelected.toggle()
    }
    @objc
    private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        logger.info(code)
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            rtmpStream!.publish(myPublish)
            print("fffffffjjjjj === \(myPublish)")
            // sharedObject!.connect(rtmpConnection)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount <= LiveStreamViewController.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            rtmpConnection.connect(myuri)
            print("fffffff === \(myuri)")
            retryCount += 1
        default:
            break
        }
    }

    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        logger.error(notification)
        rtmpConnection.connect(Preference.defaultInstance.uri!)
    }
    
    @objc
    private func didEnterBackground(_ notification: Notification) {
        // rtmpStream.receiveVideo = false
    }

    @objc
    private func didBecomeActive(_ notification: Notification) {
        // rtmpStream.receiveVideo = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if Thread.isMainThread {
            //streamView.toggleFlashButton.text = "\(rtmpStream.currentFPS)"
        }
    }
    
    @objc func tapScreen(_ gesture: UIGestureRecognizer) {
        if let gestureView = gesture.view, gesture.state == .ended {
            let touchPoint: CGPoint = gesture.location(in: gestureView)
            let pointOfInterest = CGPoint(x: touchPoint.x / gestureView.bounds.size.width, y: touchPoint.y / gestureView.bounds.size.height)
            print("pointOfInterest: \(pointOfInterest)")
            rtmpStream.setPointOfInterest(pointOfInterest, exposure: pointOfInterest)
        }
    }
    @objc
    private func on(_ notification: Notification) {
        //UIApplication.shared.statusBarOrientation deprecated in iOS 13.0
        guard let orientation = DeviceUtil.videoOrientation(by: (UIApplication.shared.windows.first?.windowScene!.interfaceOrientation)!) else {
            return
        }
        rtmpStream.orientation = orientation
    }

}
