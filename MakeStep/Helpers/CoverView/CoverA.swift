//
//  CoverA.swift
//  MMPlayerView
//
//  Created by Millman YANG on 2017/8/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import MMPlayerView
import AVFoundation
import EasyPeasy

class CoverA: UIView, MMPlayerCoverViewProtocol {
    weak var playLayer: MMPlayerLayer?
    fileprivate var isUpdateTime = false

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!    
    @IBOutlet weak var butLandscape: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPlay.imageView?.tintColor = UIColor.white
    }
    @IBAction func btnAction() {
        self.playLayer?.delayHideCover()
        if playLayer?.player?.rate == 0{
            self.playLayer?.player?.play()
        } else {
            self.playLayer?.player?.pause()
        }
    }
    
    @IBAction func btnLandscapeAction(_ sender: Any) {
        let ch = ChanellVC()
        self.playLayer!.shrinkView(onVC: ch, isHiddenVC: false) { [weak self] () -> UIView? in
            guard let self = self, let path = ch.findCurrentPath() else {return nil}
            let cell = ch.findCurrentCell(path: path) as! PlayerViewCell
            let url = URL(string: (cell.data?.streams?.first?.vodUrl)!) 
            ch.profileView.mmPlayerLayer.set(url: url)
            ch.profileView.mmPlayerLayer.resume()
            return cell.backgroundImage
        }
    }
    func currentPlayer(status: PlayStatus) {
        switch status {
        case .playing:
            self.btnPlay.setImage(#imageLiteral(resourceName: "Play"), for: .normal)//
        default:
            self.btnPlay.setImage(#imageLiteral(resourceName: "PlayLand"), for: .normal)
        }
    }
    
    func timerObserver(time: CMTime) {
        if let duration = self.playLayer?.player?.currentItem?.asset.duration ,
            !duration.isIndefinite ,
            !isUpdateTime {
            if self.playSlider.maximumValue != Float(duration.seconds) {
                self.playSlider.maximumValue = Float(duration.seconds)
            }
            self.labCurrent.text = time.seconds.convertSecondString()
            self.labTotal.text = (duration.seconds-time.seconds).convertSecondString()
            self.playSlider.value = Float(time.seconds)
        }
    }
    
    @IBAction func sliderValueChange(slider: UISlider) {
        self.isUpdateTime = true
        self.playLayer?.delayHideCover()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delaySeekTime), object: nil)
        self.perform(#selector(delaySeekTime), with: nil, afterDelay: 0.1)
    }
    
    @objc func delaySeekTime() {
        let time =  CMTimeMake(value: Int64(self.playSlider.value), timescale: 1)
        self.playLayer?.player?.seek(to: time, completionHandler: { [unowned self] (finish) in
            self.isUpdateTime = false
        })
    }
    
    func player(isMuted: Bool) {
        
    }
}
