//
//  PlayerView.swift
//  MakeStep
//
//  Created by Sergey on 14.10.2021.
//

import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}

