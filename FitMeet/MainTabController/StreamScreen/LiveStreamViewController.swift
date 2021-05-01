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

class LiveStreamViewController: UITabBarController {
    
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
        streamView.cameraModeButton.isHidden = true
        print("ChanellllID =========== \(channelId)")
        print("USERNAME ====================\(UserId)/n\(userName)/n\(streanUrl)/n\(channelId)")
        
//        if channelId == nil {
//            self.fetchChannel(name: userName, title: userName, description: userName)
//        } else {
//            guard let ch = channelId else { return }
//            let chanellI = Int(ch)
//            guard let chan = chanellI else { return }
//            self.fetchBroadcast(chanellId: chan, name: "BroadcastName")
//        }
           
            
        
        streamView.StartStreamButton.applyGradient(colours: [UIColor(hexString: "#EC008C"),UIColor(hexString: "#FC6767")])
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
 
        
        print("URL =============\(urls)")

        
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
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
       // streamView.previewView
        streamView.previewView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
        streamView.previewView.attachStream(rtmpStream)
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
    }

    func actionButton() {
        streamView.cameraModeButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        streamView.StartStreamButton.addTarget(self, action: #selector(startStream), for: .touchUpInside)
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
        if streamView.StartStreamButton.isSelected {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            streamView.StartStreamButton.setTitle("Resume Stream", for: [])
            streamView.StartStreamButton.anchor( right: streamView.capturePreviewView.rightAnchor, paddingRight: 20)
        } else {
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
            rtmpConnection.connect(Preference.defaultInstance.uri!)
            streamView.StartStreamButton.setTitle("Pause Stream", for: [])
            streamView.cameraModeButton.isHidden = false
            streamView.StartStreamButton.anchor( right: streamView.capturePreviewView.rightAnchor, paddingRight: 64)
        }
        streamView.StartStreamButton.isSelected.toggle()
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
    
    
    
    func fetchChannel(name: String?,title: String?,description: String?) {
        guard let name = name,let title = title, let description = description else { return }
         takeChannel = fitMeetchannel.createChannel(channel:  ChannelRequest(name: name, title: title, description: description , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
             .mapError({ (error) -> Error in
                         return error })
             .sink(receiveCompletion: { _ in }, receiveValue: { response in
                 if let idChanell = response.id {
                     print("Create Chanell")
                     UserDefaults.standard.set(idChanell, forKey: Constants.chanellID)
                    self.fetchBroadcast(chanellId: idChanell, name: response.name)
               }
         })
     }
    
    func fetchBroadcast(chanellId: Int?,name : String?) {
        guard let chanellId = chanellId,let name = name else { return }
        
        task = fitMeetStream.createBroadcas(broadcast:BroadcastRequest(channelID: chanellId, name: name, type: "STANDARD", access: "ALL", hasChat: true, isPlanned: true, onlyForSponsors: false, onlyForSubscribers: false,categoryIDS: [1], scheduledStartDate: "2021-04-28T15:32:57.135Z"))
            .mapError({ (error) -> Error in
                      print(error)
                       return error })
                     .sink(receiveCompletion: { _ in }, receiveValue: { response in
                        
                        UserDefaults.standard.set(response.id, forKey: Constants.broadcastID)
                        self.fetchStream(id: response.id, name: self.nameStream ?? "NameStream")
                    print(response)
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
                    guard let url = response.url else { return }
                    UserDefaults.standard.set(url, forKey: Constants.urlStream)
                    self.url = url
                    print(response)
            })
           }
    
    
    
    func removeUrl(url: String) -> (url:String,publish: String) {
        let fullUrlArr = url.components(separatedBy: "/")
        print(fullUrlArr)
        let myuri = fullUrlArr[0] + "//" + fullUrlArr[2] + "/" + fullUrlArr[3]
        let myPublish = fullUrlArr[4]
        print("myuri ========\(myuri)\n ffffffff=====\(myPublish)")
        return (myuri,myPublish)
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
    
}
