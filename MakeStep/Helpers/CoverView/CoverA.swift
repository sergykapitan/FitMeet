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
import ContextMenuSwift

class CoverA: UIView, MMPlayerCoverViewProtocol {
    func landscapePlayer() {
        print("landscape")
    }
    
    func currentStream360(streams: String) {
        self.stream360 = streams
    }
    
    func currentStream480(streams: String) {
        self.stream480 = streams
    }
    
    func currentStream720(streams: String) {
        self.stream720 = streams
    }
    
    func currentStream1080(streams: String) {
        self.stream1080 = streams
    }
    
    var stream360: String?
    var stream480: String?
    var stream720: String?
    var stream1080: String?
    
    weak var playLayer: MMPlayerLayer?
    fileprivate var isUpdateTime = false

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var labTotal: UILabel!
    @IBOutlet weak var labCurrent: UILabel!    
    @IBOutlet weak var butLandscape: UIButton!
    @IBOutlet weak var btnLand: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPlay.imageView?.tintColor = UIColor.white
       
    }
    @IBAction func btnAction() {
        self.playLayer?.delayHideCover()
        if playLayer?.player?.rate == 0 {
            self.playLayer?.player?.play()
        } else {
            self.playLayer?.player?.pause()
        }
    }
    
    @IBAction func btnLandTwo(_ sender: UIButton) {
        let cc = ButtonOffline()
        sender.isSelected.toggle()
        
        if sender.isSelected {
            AppUtility.lockOrientation(.all, andRotateTo: .landscapeLeft)
            self.playLayer?.fullScreenWhenLandscape = true
            self.playLayer!.landView(isHiddenVC: false, maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height) { [weak self] () -> UIView? in
            
                   guard  let path = cc.findCurrentPath() else {return nil}
                   let cell = cc.findCurrentCell(path: path) as! PlayerViewCell
                   let url = URL(string: (cell.data?.streams?.first?.vodUrl)!)
                   cc.offlineView.mmPlayerLayer.set(url: url)
                   cc.offlineView.mmPlayerLayer.resume()
                   return cell.backgroundImage
               }
        } else {
            self.playLayer?.fullScreenWhenLandscape = false
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            self.playLayer?.dissmisLand()
            self.playLayer?.setCoverView(enable: true)
        }
    }
    
    @IBOutlet weak var viewBtn: UIButton!
    
    @IBAction func btnSettingVod(_ sender: Any) {
        Player()
                
    }
    @IBAction func btnLandscapeAction(_ sender: Any) {
        let ch = ButtonOffline()
        self.playLayer!.shrinkView(onVC: ch, isHiddenVC: false) { [weak self] () -> UIView? in
            guard let self = self, let path = ch.findCurrentPath() else {return nil}
            let cell = ch.findCurrentCell(path: path) as! PlayerViewCell
            let url = URL(string: (cell.data?.streams?.first?.vodUrl)!)
            ch.offlineView.mmPlayerLayer.set(url: url)
            ch.offlineView.mmPlayerLayer.resume()
            return cell.backgroundImage
        }
       
    }
    func Player() {
       
        let button360 = ContextMenuItemWithImage(title: "360", image: #imageLiteral(resourceName: "play2"))
        let button480 = ContextMenuItemWithImage(title: "480", image: #imageLiteral(resourceName: "play2"))
        let button720 = ContextMenuItemWithImage(title: "720", image: #imageLiteral(resourceName: "play2"))
        let button1080 = ContextMenuItemWithImage(title: "1080", image: #imageLiteral(resourceName: "play2"))


        CM.items = [ button360,button480,button720,button1080 ]
        CM.MenuConstants.MenuWidth = 120
        CM.MenuConstants.HorizontalMarginSpace = 30
        CM.MenuConstants.LabelDefaultColor = UIColor(hexString: "#C4C4C4")
        CM.showMenu(viewTargeted: viewBtn, delegate: self,animated: true)
        CM.MenuConstants.BlurEffectEnabled = false
        
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
extension CoverA : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
       
        if index == 0 {
           print("360")
            guard let stream = stream360 else { return true}
            let cc = ButtonOffline()
            let url = URL(string: stream)
            cc.offlineView.mmPlayerLayer.set(url: url)
            cc.offlineView.mmPlayerLayer.resume()
            return true
        }
        if index == 1 {
            print("480")
            guard let stream = stream480 else { return true}
            let cc = ButtonOffline()
            let url = URL(string: stream)
            cc.offlineView.mmPlayerLayer.set(url: url)
            cc.offlineView.mmPlayerLayer.resume()
            return true
        }
        if index == 2 {
            print("720")
            guard let stream = stream720 else { return true}
            let cc = ButtonOffline()
            let url = URL(string: stream)
            cc.offlineView.mmPlayerLayer.set(url: url)
            cc.offlineView.mmPlayerLayer.resume()
            return true
        }
        if index == 3 {
            print("1080")
            guard let stream = stream1080 else { return true}
            let cc = ButtonOffline()
            let url = URL(string: stream)
            cc.offlineView.mmPlayerLayer.set(url: url)
            cc.offlineView.mmPlayerLayer.resume()
            return true
        }
        return false
       
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        if index == 0 {
        }
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
       // CM.closeAllViews()
    }
    
    
    
    
}
