//
//  LiveStreamVC.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation
import UIKit
import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox
import Loaf

class LiveStreamVC: UIViewController,RTMPStreamDelegate {
   
    
    let liveStreamView = LiveStreamVCCode()
    private var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    
    // Default Camera
    private var defaultCamera: AVCaptureDevice.Position = .back
    
    // Flag indicates if we should be attempting to go live
    private var liveDesired = false
    
    // Reconnect attempt tracker
    private var reconnectAttempt = 0
    
    // The RTMP Stream key to broadcast to.
    public var streamKey: String!
    
    // The Preset to use
    public var preset: Preset!
    
    // A tracker of the last time we changed the bitrate in ABR
    private var lastBwChange = 0
    
    // The RTMP endpoint
    let rtmpEndpoint = "rtmp://vp-push-ix1.gvideo.co/in/67530?e72c780ac65102e6c42a81e751fb3cb2"
    enum Preset {
        case hd_1080p_30fps_5mbps
        case hd_720p_30fps_3mbps
        case sd_540p_30fps_2mbps
        case sd_360p_30fps_1mbps
    }
    // An encoding profile - width, height, framerate, video bitrate
    private class Profile {
        public var width : Int = 0
        public var height : Int = 0
        public var frameRate : Int = 0
        public var bitrate : Int = 0
        
        init(width: Int, height: Int, frameRate: Int, bitrate: Int) {
            self.width = width
            self.height = height
            self.frameRate = frameRate
            self.bitrate = bitrate
        }
    }
    // Converts a Preset to a Profile
    private func presetToProfile(preset: Preset) -> Profile {
        switch preset {
        case .hd_1080p_30fps_5mbps:
            return Profile(width: 1920, height: 1080, frameRate: 30, bitrate: 5000000)
        case .hd_720p_30fps_3mbps:
            return Profile(width: 1280, height: 720, frameRate: 30, bitrate: 3000000)
        case .sd_540p_30fps_2mbps:
            return Profile(width: 960, height: 540, frameRate: 30, bitrate: 2000000)
        case .sd_360p_30fps_1mbps:
            return Profile(width: 640, height: 360, frameRate: 30, bitrate: 1000000)
        }
    }
    // Configures the live stream
    private func configureStream(preset: Preset) {
        
        let profile = presetToProfile(preset: preset)
        
        // Configure the capture settings from the camera
        rtmpStream.captureSettings = [
            .sessionPreset: AVCaptureSession.Preset.hd1920x1080,
            .continuousAutofocus: true,
            .continuousExposure: true,
            .fps: profile.frameRate
        ]
        
        // Get the orientation of the app, and set the video orientation appropriately
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            let videoOrientation = DeviceUtil.videoOrientation(by: orientation)
            rtmpStream.orientation = videoOrientation!
            rtmpStream.videoSettings = [
                .width: (orientation.isPortrait) ? profile.height : profile.width,
                .height: (orientation.isPortrait) ? profile.width : profile.height,
                .bitrate: profile.bitrate,
                .profileLevel: kVTProfileLevel_H264_Main_AutoLevel,
                .maxKeyFrameIntervalDuration: 2, // 2 seconds
            ]
        }
        
        // Configure the RTMP audio stream
        rtmpStream.audioSettings = [
            .bitrate: 128000 // Always use 128kbps
        ]
    }
    // Publishes the live stream
    private func publishStream() {
        print("Calling publish()")
        //rtmpStream.publish(self.streamKey)
        rtmpStream.publish("Live")
        
        DispatchQueue.main.async {
            self.liveStreamView.videoModeButton.setTitle("Stop Streaming!", for: .normal)
        }
    }
    private func connectRTMP() {
        print("Calling connect()")
        rtmpConnection.connect(rtmpEndpoint)
    }
    override func loadView() {
        super.loadView()
        view = liveStreamView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
        print("Broadcast View Controller Init")
        // Work out the orientation of the device, and set this on the RTMP Stream
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        // Get the orientation of the app, and set the video orientation appropriately
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            let videoOrientation = DeviceUtil.videoOrientation(by: orientation)
            rtmpStream.orientation = videoOrientation!
        }
        // And a listener for orientation changes
        // Note: Changing the orientation once the stream has been started will not change the orientation of the live stream, only the preview.
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Configure the encoder profile
        configureStream(preset: self.preset)
     
        // Attatch to the default audio device
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            print(error.description)
        }
        // Attatch to the default camera
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: defaultCamera)) { error in
            print(error.description)
        }

        // Register a tap gesture recogniser so we can use tap to focus
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        liveStreamView.previewView.addGestureRecognizer(tap)
        liveStreamView.previewView.isUserInteractionEnabled = true
        
        // Attatch the preview view
        liveStreamView.previewView.attachStream(rtmpStream)
        
        // Add event listeners for RTMP status changes and IO Errors
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        
        rtmpStream.delegate = self
                
        liveStreamView.videoModeButton.setTitle("Go Live!", for: .normal)
    }
    
    func actionButton() {
        liveStreamView.videoModeButton.addTarget(self, action: #selector(nextView), for: .touchUpInside)
    }
    
    @objc func nextView() {
        print("Go Live Button tapped!")
        
        if !liveDesired {
            
            if rtmpConnection.connected {
                // If we're already connected to the RTMP server, wr can just call publish() to start the stream
                publishStream()
            } else {
                // Otherwise, we need to setup the RTMP connection and wait for a callback before we can safely
                // call publish() to start the stream
                connectRTMP()
            }

            // Modify application state to streaming
            liveDesired = true
            liveStreamView.videoModeButton.setTitle("Connecting...", for: .normal)
        } else {
            // Unpublish the live stream
            rtmpStream.close()

            // Modify application state to idle
            liveDesired = false
            liveStreamView.videoModeButton.setTitle("Go Live!", for: .normal)
        }
    }
    
    func rtmpStreamDidClear(_ stream: RTMPStream) {
           
       }
    
    @objc
    private func on(_ notification: Notification) {
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            let videoOrientation = DeviceUtil.videoOrientation(by: orientation)
            rtmpStream.orientation = videoOrientation!
            
            // Do not change the outpur rotation if the stream has already started.
            if liveDesired == false {
                let profile = presetToProfile(preset: self.preset)
                rtmpStream.videoSettings = [
                    .width: (orientation.isPortrait) ? profile.height : profile.width,
                    .height: (orientation.isPortrait) ? profile.width : profile.height
                ]
            }
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let point = sender.location(in: liveStreamView.previewView)
            let pointOfInterest = CGPoint(x: point.x / liveStreamView.previewView.bounds.size.width, y: point.y / liveStreamView.previewView.bounds.size.height)
            rtmpStream.setPointOfInterest(pointOfInterest, exposure: pointOfInterest)
        }
    }
    // Called when the RTMPStream or RTMPConnection changes status
    @objc
    private func rtmpStatusHandler(_ notification: Notification) {
        print("RTMP Status Handler called.")
        
        let e = Event.from(notification)
                guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
                    return
                }

        // Send a nicely styled notification about the RTMP Status
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
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            reconnectAttempt = 0
            if liveDesired {
                // Publish our stream to our stream key
                publishStream()
            }
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            print("RTMP Connection was not successful.")
            
            // Retry the connection if "live" is still the desired state
            if liveDesired {
                
                reconnectAttempt += 1
                
                DispatchQueue.main.async {
                    self.liveStreamView.videoModeButton.setTitle("Reconnect attempt " + String(self.reconnectAttempt) + " (Cancel)" , for: .normal)
                }
                // Retries the RTMP connection every 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.connectRTMP()
                }
            }
        default:
            break
        }
    }
    // Called when there's an RTMP Error
    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        print("RTMP Error Handler called.")
    }
    // Statistics callback
    func rtmpStream(_ stream: RTMPStream, didStatics connection: RTMPConnection) {
        DispatchQueue.main.async {
            self.liveStreamView.labelSignUp.text = String(stream.currentFPS) + " fps"
          //  self.liveStreamView.labelSignUp.text = String((connection.currentBytesOutPerSecond / 125)) + " kbps"
        }
    }
    
    // Insufficient bandwidth callback
    func rtmpStream(_ stream: RTMPStream, didPublishInsufficientBW connection: RTMPConnection) {
        print("ABR: didPublishInsufficientBW")
        
        // If we last changed bandwidth over 10 seconds ago
        if (Int(NSDate().timeIntervalSince1970) - lastBwChange) > 5 {
            print("ABR: Will try to change bitrate")
            
            // Reduce bitrate by 30% every 10 seconds
            let b = Double(stream.videoSettings[.bitrate] as! UInt32) * Double(0.7)
            print("ABR: Proposed bandwidth: " + String(b))
            stream.videoSettings[.bitrate] = b
            lastBwChange = Int(NSDate().timeIntervalSince1970)
            
            DispatchQueue.main.async {
                Loaf("Insuffient Bandwidth, changing video bandwidth to: " + String(b), state: Loaf.State.warning, location: .top,  sender: self).show(.short)
            }
            
        } else {
            print("ABR: Still giving grace time for last bandwidth change")
        }
    }
    
    // Today this example doesn't attempt to increase bandwidth to find a sweet spot.
    // An implementation might be to gently increase bandwidth by a few percent, but that's hard without getting into an aggressive cycle.
    func rtmpStream(_ stream: RTMPStream, didPublishSufficientBW connection: RTMPConnection) {
    }
}
