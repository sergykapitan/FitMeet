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
import Combine
import Loaf



final class ExampleRecorderDelegate: DefaultAVRecorderDelegate {
    static let `default` = ExampleRecorderDelegate()

    override func didFinishWriting(_ recorder: AVRecorder) {
        guard let writer: AVAssetWriter = recorder.writer else {
            return
        }
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
        }, completionHandler: { _, error -> Void in
            do {
                try FileManager.default.removeItem(at: writer.outputURL)
            } catch {
                print(error)
            }
        })
    }
}
class LiveStreamViewController: UITabBarController ,ClassBVCDelegate,ClassUserDelegate{
    
    func changeButton() {
    }
    var isLandscape: Bool = false
    func changeUp(key: CGFloat) {
        
    }
    func changeDown(key: CGFloat) {
        
    }
    func changeBackgroundColor() {
    }
    
    
    let streamView = LiveStreamVCCode()
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetchannel: FitMeetChannels
    
    let UserId = UserDefaults.standard.string(forKey: Constants.userID)
    let userName = UserDefaults.standard.string(forKey: Constants.userFullName)
    let streanUrl = UserDefaults.standard.string(forKey: Constants.urlStream)
    let channelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    let urls = UserDefaults.standard.string(forKey: Constants.urlStream)
    
    
    
    
    private var takeChannel: AnyCancellable?
    private var task: AnyCancellable?
    private var taskStream: AnyCancellable?
    private static let maxRetryCount: Int = 5
    var nameStream: String?
    var url: String?
    var myuri: String = ""
    var myPublish: String = ""
    
    var idBroadcast: Int = 0
    var idBroad: Int?
    var chanell: Int?
    var isPrivate: Bool = false
    var privateUrlKey: String?
    
    
    var captureSession: AVCaptureSession!
    var videoInput: AVCaptureDeviceInput!
    
    var timer: Timer?
    var isPaused = true
    
    private var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var sharedObject: RTMPSharedObject!
    private var currentEffect: VideoEffect?
    private var currentPosition: AVCaptureDevice.Position = .back
    private var retryCount: Int = 0
    var broadcastId: Int?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    let actionChatTransitionManager = ActionTransishionChatManadger()
    
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
            .continuousExposure: true,
           // .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
        ]
        rtmpStream.videoSettings = [
            .width: 720,
            .height: 1280,
            .bitrate: 1000 * 1000,
            //.profileLevel: kVTProfileLevel_H264_Baseline_3_1,
        ]
        
        rtmpStream.captureSettings[.fps] = 60.0
        
        rtmpStream.mixer.recorder.delegate = ExampleRecorderDelegate.shared
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        view.addGestureRecognizer(tap)
        
        streamView.recButton.isHidden = true
        streamView.stopButton.isHidden = true
        
 
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        logger.info("viewWillAppear")
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            logger.warn(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            logger.warn(error.description)
        }
        streamView.previewView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
        streamView.previewView.attachStream(rtmpStream)
        if isPrivate {
            streamView.stackButton.addArrangedSubview(streamView.privateStream)
        } 
    }
    override func viewWillDisappear(_ animated: Bool) {
        logger.info("viewWillDisappear")
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isHidden = false
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        rtmpStream.close()
        rtmpStream.dispose()
        myuri = ""
        myPublish = ""
        Loaf.dismiss(sender: LiveStreamViewController())
    }

    func actionButton() {
        streamView.cameraModeButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        streamView.StartStreamButton.addTarget(self, action: #selector(startStream), for: .touchUpInside)
        streamView.microfoneButton.addTarget(self, action: #selector(stopMicrofone), for: .touchUpInside)
        streamView.cameraButton.addTarget(self, action: #selector(settingStream), for: .touchUpInside)
        streamView.stopButton.addTarget(self, action: #selector(stopStream), for: .touchUpInside)
        streamView.chatButton.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        streamView.usrButton.addTarget(self, action: #selector(openUserOnline), for: .touchUpInside)
        streamView.privateStream.addTarget(self, action: #selector(shareLink), for: .touchUpInside)
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
    @objc func shareLink() {        
        guard let id = broadcastId,let privateKey = privateUrlKey else { return }
 
        #if QA
            "https://makestep.com/broadcastQA/\(id)/\(privateKey)".share()
        #elseif DEBUG
            "https://makestep.com/broadcast/\(id)/\(privateKey)".share()
        #endif
    }
    // MARK: - presentChat
    
    @objc func openChat() {
        
        let chatVC = ChatVC()
        chatVC.transitioningDelegate = actionChatTransitionManager
        chatVC.modalPresentationStyle = .custom
        chatVC.delegate = self
        guard let id = idBroad,let channel = channelId else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = channel
        actionChatTransitionManager.intWidth = 1
        actionChatTransitionManager.intHeight = 0.7
        actionChatTransitionManager.isLandscape = isLandscape
        present(chatVC, animated: true)

    }
    @objc func openUserOnline() {
        
        streamView.recButton.isHidden = true
        streamView.stopButton.isHidden = true
        streamView.microfoneButton.isHidden = true
        streamView.cameraModeButton.isHidden = true
        streamView.cameraButton.isHidden = true
        streamView.chatButton.isHidden = true
        streamView.StartStreamButton.isHidden = true
        

        let chatVC = UserVC()
        guard let id = idBroad,let channel = channelId else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = channel
        chatVC.delegate = self
        
        chatVC.transitioningDelegate = actionChatTransitionManager
        chatVC.modalPresentationStyle = .custom
        if isLandscape {
            chatVC.isLand = true
            actionChatTransitionManager.intWidth = 0.5
            actionChatTransitionManager.intHeight = 1
            
            present(chatVC, animated: true, completion: nil)
        } else {
            chatVC.isLand = false
            actionChatTransitionManager.intWidth = 1
            actionChatTransitionManager.intHeight = 0.7
            actionChatTransitionManager.isLandscape = isLandscape
            present(chatVC, animated: true)
        }
     
    }

    @objc func settingStream() {
        streamView.cameraButton.isSelected.toggle()
        captureSession = AVCaptureSession()
        
        
        if streamView.cameraButton.isSelected {
   
            UIApplication.shared.isIdleTimerDisabled = false
            streamView.previewView.isHidden = true
            self.rtmpStream.paused = true
            self.rtmpStream.receiveVideo = false
            streamView.cameraButton.setImage(#imageLiteral(resourceName: "notcamera"), for: [])
        } else {
            streamView.previewView.isHidden = false
            self.rtmpStream.paused = false
            self.rtmpStream.receiveVideo = true
            UIApplication.shared.isIdleTimerDisabled = true
            streamView.cameraButton.setImage(#imageLiteral(resourceName: "camera"), for: [])
            
        }
    }

    private func alertNameStream() {
        let alertController = UIAlertController(title: "Stream Name", message: "Problem", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction);
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func startStream() {
      
        if myuri != nil {            
        if streamView.StartStreamButton.isSelected {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            streamView.StartStreamButton.setImage(#imageLiteral(resourceName: "startCamera"), for: [])
            createTimer()
            self.streamView.stackButton.addArrangedSubview(streamView.stopButton)
            streamView.recButton.isHidden = true
            streamView.stopButton.isHidden = false
            streamView.microfoneButton.isHidden = true
            streamView.cameraModeButton.isHidden = true
            streamView.cameraButton.isHidden = true
           
            

            
        } else {
            createTimer()
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            rtmpConnection.connect(myuri)
            streamView.recButton.isHidden = false
            
            streamView.StartStreamButton.setImage(#imageLiteral(resourceName: "pause"), for: [])
            streamView.stopButton.isHidden = true
            
            streamView.microfoneButton.isHidden = false
            streamView.cameraModeButton.isHidden = false
            streamView.cameraButton.isHidden = false
           
                       
            
            
        }
            
        streamView.StartStreamButton.isSelected.toggle()
        } else {
            alertNameStream()
        }
    }
    @objc
    private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        var loafStyle = Loaf.State.info
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue, RTMPStream.Code.publishStart.rawValue, RTMPStream.Code.unpublishSuccess.rawValue:
            loafStyle = Loaf.State.success
        case RTMPConnection.Code.connectFailed.rawValue:
            loafStyle = Loaf.State.error
        case RTMPConnection.Code.connectClosed.rawValue:
            loafStyle = Loaf.State.warning
        default:
            break
        }
        DispatchQueue.main.async {
            Loaf("RTMP Status: " + code, state: loafStyle, location: .top,  sender: self).show(.short)
        }

        logger.info(code)
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            rtmpStream!.publish(myPublish)
            // sharedObject!.connect(rtmpConnection)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount <= LiveStreamViewController.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            rtmpConnection.connect(myuri)
            retryCount += 1
        default:
            break
        }
    }

    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        logger.error(notification)
        rtmpConnection.connect(myuri)
    }
    
    @objc
    private func didEnterBackground(_ notification: Notification) {
         rtmpStream.receiveVideo = false
    }

    @objc
    private func didBecomeActive(_ notification: Notification) {
         rtmpStream.receiveVideo = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if Thread.isMainThread {
            streamView.labelFPS.text = "FPS:\(rtmpStream.currentFPS)"
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

    @objc func stopMicrofone() {
        streamView.microfoneButton.isSelected.toggle()
        
        if streamView.microfoneButton.isSelected {

            streamView.microfoneButton.setImage(#imageLiteral(resourceName: "notmicrofone"), for: [])
                       self.rtmpStream.audioSettings = [
                           .muted: true,
                           .bitrate: 32 * 1000,
                       
                       ]
        } else {
            streamView.microfoneButton.setImage(#imageLiteral(resourceName: "microfone"), for: [])
                        self.rtmpStream.audioSettings = [
                            .muted: false,
                            .bitrate: 32 * 1000,
                        
                        ]
        }
    }
    
    @objc func stopStream() {
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)
    }

    func createTimer() {
        
        if isPaused{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
               isPaused = false
           } else {
              timer?.invalidate()
               isPaused = true
           }
      
    }
    @objc func updateTimer() {
 
          updateTime()
    
    }
    var counter = 0
    func updateTime() {

        let time = Date().timeIntervalSince(Date())
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours)h")
        }
        if minutes > 0 {
          times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        streamView.timerLabel.text = times.joined(separator: " ")
    
    }

    @objc func timerAction() {
           counter += 1
           updateTimer(timeElapsed: counter)
       }
    func blurEffect(key: Bool) {
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if key {
           self.view.addSubview(blurView)
        } else {
           self.view.willRemoveSubview(blurView)
        }
    }
    private func updateTimer(timeElapsed: Int) {
        let quotientRemainder = timeElapsed.quotientAndRemainder(dividingBy: 60)
        var hours = ""
        var minutes = ""
        var seconds = ""
        if quotientRemainder.quotient >= 60 {
            hours = "0\(quotientRemainder.quotient / 60)"
        } else { hours = "00"    }
        if quotientRemainder.quotient < 10 {
            minutes = "0\(quotientRemainder.quotient)"
        } else {  minutes = "\(quotientRemainder.quotient)" }
        if quotientRemainder.remainder < 10 {
            seconds = "0\(quotientRemainder.remainder)"
        } else {
            seconds = "\(quotientRemainder.remainder)"
        }
        streamView.timerLabel.text = "\(hours):\(minutes):\(seconds)"
      
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
   
           if UIDevice.current.orientation.isLandscape {
            isLandscape = true
           } else {
            isLandscape = false
           }
       }
}

