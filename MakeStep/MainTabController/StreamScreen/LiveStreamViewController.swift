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

protocol DissmisPlayer: class {
    func dissmissPlayer()    
}

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
    var filtredBroadcast: [Datum] = []
    weak var delegatePlayer: DissmisPlayer?
    var leftTextFieldConstraint = NSLayoutConstraint()
    let streamView = LiveStreamVCCode()
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetchannel: FitMeetChannels
    @Inject var fitMeetApi: FitMeetApi
    var textFieldBottomConstraint = NSLayoutConstraint()
    var user: User?
    var listChanell: [ChannelResponce] = []
    //var imagePicker: ImagePicker!
    var imagePath: String?
    var category: [Int]?
    var descriptionStream : String?
    var broadcast:  BroadcastResponce?
    
    let UserId = UserDefaults.standard.string(forKey: Constants.userID)
    let userName = UserDefaults.standard.string(forKey: Constants.userFullName)
    let streanUrl = UserDefaults.standard.string(forKey: Constants.urlStream)
    let channelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    let urls = UserDefaults.standard.string(forKey: Constants.urlStream)
    
    let actionTransitionManager = ActionTransishionChatManadger()
   
    
    
    private var takeChannel: AnyCancellable?
    private var task: AnyCancellable?
    private var taskStream: AnyCancellable?
    private var takeUser: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    
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
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
    override func loadView() {
        super.loadView()
        view = streamView
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        streamView.collectionView.delegate = self
        streamView.collectionView.dataSource = self
        self.actionButton()
        self.bindingChanell()
        self.bindingUser()
        setupKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        streamView.textFieldNameStream.delegate = self
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
//        let r = getStatusBarHeight()
//        streamView.topView.anchor(top: streamView.capturePreviewView.topAnchor,
//                                                 left: streamView.capturePreviewView.leftAnchor,
//                                                 right: streamView.capturePreviewView.rightAnchor,
//                                                 paddingTop: -r, paddingLeft: 0, paddingRight: 0,  height: 135)
//        streamView.topView.gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 135)
//        streamView.bottomView.gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 135)
      
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        logger.info("viewWillAppear")
        super.viewWillAppear(animated)
       
        
        self.bindingChanell()
           let audioSession = AVAudioSession.sharedInstance()
         _ = try? audioSession.setCategory(.playback, options: .defaultToSpeaker)
         _ = try? audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
         _ = try? audioSession.setActive(true)

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        leftTextFieldConstraint = streamView.textFieldNameStream.leadingAnchor.constraint(equalTo: streamView.capturePreviewView.leadingAnchor, constant: 10)
        leftTextFieldConstraint.isActive = false
        
        if myuri == "" {
        
        [streamView.labelFPS,streamView.timerLabel,streamView.usrButton,streamView.stackButton].forEach{ $0.alpha = 0 }
          //  [streamView.topView,streamView.bottomView,streamView.collectionView].forEach{ $0.alpha = 0 }
        [streamView.buttonStart,streamView.buttonAvailable,streamView.labelAviable,streamView.buttonStartNow,streamView.labelStartNow,streamView.textFieldNameStream,streamView.lineBottom,streamView.buttonSetting,streamView.labelSetting,streamView.close].forEach{ $0.alpha = 1 }
        
        } else {
            [streamView.labelFPS,streamView.timerLabel,streamView.usrButton,streamView.stackButton].forEach{ $0.alpha = 1 }
          //  [streamView.topView,streamView.bottomView,streamView.collectionView].forEach{ $0.alpha = 1 }
            [streamView.buttonStart,streamView.buttonAvailable,streamView.labelAviable,streamView.buttonStartNow,streamView.labelStartNow,streamView.textFieldNameStream,streamView.lineBottom,streamView.buttonSetting,streamView.labelSetting,streamView.close].forEach{ $0.alpha = 0 }
            
        }
        
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            logger.warn(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            logger.warn(error.description)
        }
        streamView.previewView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
        streamView.previewView.attachStream(rtmpStream)

    }
    override func viewWillDisappear(_ animated: Bool) {
        logger.info("viewWillDisappear")
        super.viewWillDisappear(animated)
        leftTextFieldConstraint.isActive = false
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isHidden = false
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        rtmpStream.close()
        rtmpStream.dispose()
        myuri = ""
        myPublish = ""
        Loaf.dismiss(sender: LiveStreamViewController())
        streamView.labelStartNow.text = "Start now"
        streamView.labelAviable.text = "Available for all"
        streamView.textFieldNameStream.text = nil
        streamView.timerLabel.text = "00:00:00"
        
        streamView.stopButton.isHidden = true
        
       
        streamView.microfoneButton.isHidden = false
        streamView.cameraModeButton.isHidden = false
        streamView.cameraButton.isHidden = false
    }

    func actionButton() {
        streamView.cameraModeButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        streamView.StartStreamButton.addTarget(self, action: #selector(startStream), for: .touchUpInside)
        streamView.microfoneButton.addTarget(self, action: #selector(stopMicrofone), for: .touchUpInside)
        streamView.cameraButton.addTarget(self, action: #selector(settingStream), for: .touchUpInside)
        streamView.stopButton.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        streamView.chatButton.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        streamView.usrButton.addTarget(self, action: #selector(openUserOnline), for: .touchUpInside)
        streamView.privateStream.addTarget(self, action: #selector(shareLink), for: .touchUpInside)
        
        
//        streamView.topView.buttonStart.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
//        streamView.topView.collectionUser.addTarget(self, action: #selector(colectionUser), for: .touchUpInside)
//        streamView.topView.usrButton.addTarget(self, action: #selector(openUserOnline), for: .touchUpInside)
//        streamView.bottomView.microfoneBtn.addTarget(self, action: #selector(stopMicrofone), for: .touchUpInside)
//        streamView.bottomView.buttonPause.addTarget(self, action:  #selector(startStream), for: .touchUpInside)
//        streamView.bottomView.chatBtn.addTarget(self, action: #selector(openChat), for: .touchUpInside)
        
        
        streamView.close.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        streamView.buttonSetting.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        streamView.buttonStartNow.addTarget(self, action: #selector(timeTapped), for: .touchUpInside)
        streamView.buttonAvailable.addTarget(self, action: #selector(aviableTapped), for: .touchUpInside)
        streamView.buttonStart.addTarget(self, action: #selector(actionStartStream), for: .touchUpInside)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        streamView.capturePreviewView.addGestureRecognizer(scrollViewTap)
        
        textFieldBottomConstraint = streamView.textFieldNameStream.bottomAnchor.constraint(equalTo: streamView.buttonAvailable.topAnchor, constant: -32)
        textFieldBottomConstraint.isActive = true
    }
    @objc func colectionUser() {
        self.binding()
    }
    @objc func aviableTapped() {
        self.presentAviable()
        }
    @objc func viewTapped() {
            self.view.endEditing(true)
        }
    @objc func timeTapped() {
        self.showPicker()
        }
    @objc func settingTapped() {
        let chatVC = NewStartStream()
        chatVC.delegate = self
        if let category = category {
            chatVC.IdCategory = category
            chatVC.authView.textFieldCategory.placeholder = ""
        }
        if let imagePath = imagePath {
            chatVC.imagePath = imagePath
        }
        if let descriptionStream = descriptionStream {
            chatVC.authView.textFieldDescription.text = descriptionStream
        }
        self.present(chatVC, interactiveDismissalType: .standard)
        }
    @objc func closeVideo() {
        logger.info("close")
        self.timer?.invalidate()
        if let tabBar = tabBarController {
            tabBar.selectedIndex = 0
        } else {
            dismiss(animated: true) {
                self.delegatePlayer?.dissmissPlayer()
            }
        }
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
        guard let id = self.broadcast?.id, let channelId = listChanell.last?.id else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = "\(channelId)"
        actionChatTransitionManager.intWidth = 1
        actionChatTransitionManager.intHeight = 0.7
        actionChatTransitionManager.isLandscape = isLandscape
        present(chatVC, animated: true)

    }
    @objc func openUserOnline() {
 
        let chatVC = UserVC()
        guard let id = self.broadcast?.id, let channelId = listChanell.last?.id else { return }
        chatVC.broadcastId = "\(id)"
        chatVC.chanellId = "\(channelId)"
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
      
        if myuri != "" {
        if streamView.StartStreamButton.isSelected {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            streamView.StartStreamButton.setImage(#imageLiteral(resourceName: "startCamera"), for: [])
            createTimer()
            self.streamView.stackButton.addArrangedSubview(streamView.stopButton)

            streamView.stopButton.isHidden = false

            streamView.recButton.isHidden = true
            streamView.microfoneButton.isHidden = true
            streamView.cameraModeButton.isHidden = true
            streamView.cameraButton.isHidden = true




        } else {
            createTimer()
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            rtmpConnection.connect(myuri)


            streamView.StartStreamButton.setImage(#imageLiteral(resourceName: "pause"), for: [])
            streamView.stopButton.isHidden = true

            streamView.recButton.isHidden = false
            streamView.microfoneButton.isHidden = false
            streamView.cameraModeButton.isHidden = false
            streamView.cameraButton.isHidden = false




        }
//            if streamView.bottomView.buttonPause.isSelected {
//                UIApplication.shared.isIdleTimerDisabled = false
//                rtmpConnection.close()
//                rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
//                rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
//
//                createTimer()
//
//                streamView.bottomView.buttonPause.setImage(UIImage(named: "pauseStream2"), for: [])
//
//
//
//
//
//            } else {
//                createTimer()
//                UIApplication.shared.isIdleTimerDisabled = true
//                rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
//                rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
//                rtmpConnection.connect(myuri)
//
//
//                streamView.bottomView.buttonPause.setImage(UIImage(named: "pauseStream"), for: [])
//
//
//
//
//            }
            
            streamView.StartStreamButton.isSelected.toggle()
          //  streamView.bottomView.buttonPause.isSelected.toggle()
        } else {
            alertNameStream()
        }
    }
    @objc private func rtmpStatusHandler(_ notification: Notification) {
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
    @objc private func rtmpErrorHandler(_ notification: Notification) {
        logger.error(notification)
        rtmpConnection.connect(myuri)
    }
    @objc private func didEnterBackground(_ notification: Notification) {
         rtmpStream.receiveVideo = false
    }
    @objc private func didBecomeActive(_ notification: Notification) {
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
    @objc  private func on(_ notification: Notification) {
        //UIApplication.shared.statusBarOrientation deprecated in iOS 13.0
        guard let orientation = DeviceUtil.videoOrientation(by: (UIApplication.shared.windows.first?.windowScene!.interfaceOrientation)!) else {
            return
        }
        rtmpStream.orientation = orientation
    }
    @objc func stopMicrofone() {
//        streamView.bottomView.microfoneBtn.isSelected.toggle()
//        if streamView.bottomView.microfoneBtn.isSelected {
//            streamView.bottomView.microfoneBtn.setImage(UIImage(named: "microfoneUserOff"), for: [])
//            self.rtmpStream.audioSettings = [ .muted: true,.bitrate: 32 * 1000, ]
//        } else {
//            streamView.bottomView.microfoneBtn.setImage(UIImage(named: "microfoneUser"), for: [])
//            self.rtmpStream.audioSettings = [ .muted: false, .bitrate: 32 * 1000, ]
//        }
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
    private func showPicker() {
        var style = DefaultStyle()
        style.pickerColor = StyleColor.colors([style.textColor, .red, .blueColor])
        style.pickerMode = .dateAndTime
        style.titleString = "Please Сhoose Date"
        style.returnDateFormat = .yyyy_To_ss
        style.minimumDate = Date()
        style.maximumDate = Date().addingTimeInterval(3600*24*7*52)
        style.titleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
    
        style.textColor = UIColor(hexString: "#3B58A4")
        let pick:PresentedViewController = PresentedViewController()
        pick.style = style
        pick.block = { [weak self] (date) in
            if date == "" {
            self?.streamView.labelStartNow.text = "Start Now"
            } else {
            self?.streamView.labelStartNow.text = self?.removeUrl(str: date!)
            }
        }
        self.present(pick, animated: true, completion: nil)
    }
    func removeUrl(str: String) -> (String) {
        let fullUrlArr = str.components(separatedBy: " ")
        let myuri = fullUrlArr[0] + "\n"  + "     " + fullUrlArr[1]
        return (myuri)
    }
}

extension LiveStreamViewController: SendDataToLive {
    
    func sendDatatoLive(category: [Int], description: String?, imagePath: String?) {
        self.imagePath = imagePath
        self.category = category
        self.descriptionStream = description
    }
    public func presentAviable() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let action = self.action(for: "Available for all", title: " Available for all")
                     DispatchQueue.main.async {
                     alertController.addAction(action!)
                     }
                
       let action2 = self.action(for: "Private stream", title: "Private stream")
                    DispatchQueue.main.async {
                    alertController.addAction(action2!)
                    }
                DispatchQueue.main.async {
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                }
                
                DispatchQueue.main.async {
                   self.present(alertController, animated: true)
                }
       
            
        
    }
    private func action(for type: String, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
           
            switch type {
            case "Available for all" :
                self.streamView.labelAviable.text = type
            case "Private stream" :
                self.streamView.labelAviable.text = type
            default:
               break
            }
           
        }
    }
}
extension LiveStreamViewController {
    func bindingUser() {
        takeUser = fitMeetApi.getUser()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.username != nil  {
                    self.user = response
                    
                }
        })
    }
    func bindingChanell() {
        takeChannel = fitMeetchannel.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if !response.data.isEmpty  {
                    self.listChanell = response.data
                    let nameStream = self.returnNameChannelAndDate()
                    self.streamView.textFieldNameStream.attributedPlaceholder =
                    NSAttributedString(string: nameStream, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
                }
        })
    }
    @objc func actionStartStream() {
        guard let chanelId = listChanell.last?.id else { return }
        streamView.circleIndicator.alpha = 1
        streamView.circleIndicator
            .rotateSpeed(0.6)
            .interval(0.3)
            .animate()
                var isPlan: Bool?
                var date: String?
                var status: String?
      
        
                var onlyForSponsors : Bool?
                var onlyForSubscribers: Bool?
        
                if streamView.labelStartNow.text == "Start now" {
                    isPlan = false
                    date = "\(Date())"
                } else {
                    isPlan = true
                    date = streamView.labelStartNow.text
                }
        if streamView.labelAviable.text == "Available for all" {
                     status = "STANDARD"
        }  else if streamView.labelAviable.text == "Private stream" {
                    status = "PRIVATE_LINK"
        }
        let image =  self.imagePath ?? ""
        guard let date = date,let status = status,let isPlan = isPlan,var name = streamView.textFieldNameStream.text else {  return }
        if name.isEmpty {
            name = returnNameChannelAndDate()
        }

        self.nextView(chanellId: chanelId, name: name, description: descriptionStream ?? "", previewPath: image, isPlaned: isPlan, date: date, onlyForSponsors: false, onlyForSubscribers: false, categoryId: self.category ?? [], type: status )
    }
    func nextView(chanellId: Int ,name: String , description: String,previewPath: String,isPlaned: Bool,date: String,onlyForSponsors: Bool,onlyForSubscribers:Bool,categoryId: [Int],type: String)  {

        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(
                                                    channelID: chanellId,
                                                    name: name,
                                                    type: type,
                                                    access: "ALL",
                                                    hasChat: true,
                                                    isPlanned: isPlaned,
                                                    onlyForSponsors: onlyForSponsors,
                                                    onlyForSubscribers: onlyForSubscribers,
                                                    categoryIDS: categoryId,
                                                    scheduledStartDate: date,
                                                    description: description,
                                                    previewPath: previewPath))

            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    self.broadcast = response
                    UserDefaults.standard.set(self.broadcast?.id, forKey: Constants.broadcastID)
                    if self.streamView.labelStartNow.text == "Start now" {
                    self.fetchStream(id: id, name: name)
                    } else {
                        
                        guard let user = self.user else { return }
                        self.streamView.circleIndicator.stop()
                        self.streamView.circleIndicator.alpha = 0
                        let channelVC = ChanellVC()
                        channelVC.user = user
                        self.imagePath = nil
                        self.navigationController?.pushViewController(channelVC, animated: true)
                    }
                } else {
                    guard let mess = response.message else { return }
                    Loaf("Not Saved \(mess)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
            }
        })
    }
    func fetchStream(id:Int?,name: String?) {
        let UserId = UserDefaults.standard.string(forKey: Constants.userID)
        guard let id = id , let name = name , let userId = UserId  else{ return }
        let usId = Int(userId)
        guard let usID = usId else { return }
        taskStream = fitMeetStream.startStream(stream: StartStream(name: name, userId: usID , broadcastId: id))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                     if let url = response.url {
                         self.startStreams(id: id, url: url)
             } else {
                 Loaf("Not Saved \(response.message!)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
             }
        })
    }
    private func startStreams(id : Int, url : String) {
        UserDefaults.standard.set(url, forKey: Constants.urlStream)
        let twoString = self.removeUrl(url: url)
        self.myuri = twoString.0
        self.myPublish = twoString.1
        self.url = url
        self.imagePath = nil
                if self.streamView.labelAviable.text == "Available for all" {
                    self.isPrivate = false
                } else  {
                    self.isPrivate = true
                    streamView.stackButton.addArrangedSubview(streamView.privateStream)
                    self.broadcastId = self.broadcast?.id
                    self.privateUrlKey = self.broadcast?.privateUrlKey
                }
        streamView.circleIndicator.stop()
        streamView.circleIndicator.alpha = 0
        
       // [streamView.topView,streamView.bottomView,streamView.collectionView].forEach{ $0.alpha = 1 }
        [streamView.labelFPS,streamView.timerLabel,streamView.usrButton,streamView.stackButton].forEach{ $0.alpha = 1 }
        [streamView.buttonStart,streamView.buttonAvailable,streamView.labelAviable,streamView.buttonStartNow,streamView.labelStartNow,streamView.textFieldNameStream,streamView.lineBottom,streamView.buttonSetting,streamView.labelSetting,streamView.close].forEach{ $0.alpha = 0 }
        startStream()
        
        
        
    }
    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        return (myuri,myPublish)
    }
    private func returnNameChannelAndDate() -> String {
        guard let name =  self.listChanell.last?.name else { return "not name chanell"}
        let df:DateFormatter = DateFormatter.init()
        df.dateFormat = "yyyy/MM/dd "
        df.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        let date = Date()
        let returnDate = df.string(from: date)
        return name + " " + "stream" + " " + returnDate
    }
    func binding() {
        takeBroadcast = fitMeetStream.getCategoryPrivate()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.filtredBroadcast = response.data!
                    
                    self.streamView.collectionView.reloadData()
                }
        })
    }
}
extension LiveStreamViewController {
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if streamView.textFieldNameStream.isFirstResponder {
                self.textFieldBottomConstraint.constant = -180
                self.streamView.textFieldNameStream.attributedPlaceholder =
                NSAttributedString(string: "TITLE OF THE STREAM", attributes: [NSAttributedString.Key.foregroundColor : UIColor.clear])
                leftTextFieldConstraint.isActive = false
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           self.textFieldBottomConstraint.constant = -32
           guard let name = streamView.textFieldNameStream.text else {  return }
            if name.isEmpty {
                let nameStream = self.returnNameChannelAndDate()
                         self.streamView.textFieldNameStream.attributedPlaceholder =
                         NSAttributedString(string: nameStream, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            }
        }
    }
}
extension LiveStreamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == streamView.textFieldNameStream {
            self.streamView.textFieldNameStream.resignFirstResponder()
            return true
        }
     return false
  }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let fullString = (textField.text ?? "") + string
        if fullString.count >= 35 {
            leftTextFieldConstraint.isActive = true
        } else {
           
            if fullString.count <= 34 {
                leftTextFieldConstraint.isActive = false
            }
        }
        return true
    }
}
