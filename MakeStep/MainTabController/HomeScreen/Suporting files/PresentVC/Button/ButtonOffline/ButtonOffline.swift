//
//  ButtonOffline.swift
//  MakeStep
//
//  Created by Sergey on 24.11.2021.
//

import Foundation
import UIKit
import Combine
import AudioToolbox
import MMPlayerView

class ButtonOffline: UIViewController {

   
    let offlineView = ButtonOfflineCode()
    var userId = 0
    var brodcast: [BroadcastResponce] = []
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)

    private var take: AnyCancellable?
    private var followBroad: AnyCancellable?
    @Inject var fitMeetApi: FitMeetApi
    @Inject var fitMeetStream: FitMeetStream
    
    let actionSheetTransitionManager = ActionSheetTransitionManager()
    var url: String?
    var user: User?
    var offsetObservation: NSKeyValueObservation?
    
    var usersd = [Int: User]()
 
    override func loadView() {
        super.loadView()
        view = offlineView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
       
        self.navigationController?.mmPlayerTransition.push.pass(setting: { (_) in
            
        })
        offsetObservation = offlineView.tableView.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = self, self.presentedViewController == nil else {return}
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.2)
        }
        offlineView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right:0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateByContentOffset()
            self?.startLoading()
        }
       
        offlineView.mmPlayerLayer.fullScreenWhenLandscape = false

        offlineView.mmPlayerLayer.getStatusBlock { [weak self] (status) in
            switch status {
            case .failed(let err):
                let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            case .ready:
                print("Ready to Play")
            case .playing:
                print("Playing")
            case .pause:
                print("Pause")
            case .end:
                print("End")
            default: break
            }
        }
        offlineView.mmPlayerLayer.getOrientationChange { (status) in
            print("Player OrientationChange \(status)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.bindingChanellVOD(userId: "\(userId)")
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if token != nil {
            self.bindingChanellVOD(userId: "\(userId)")
        } else {
            self.bindingChanellVODNotAuth(userId: "\(userId)")
        }
       
    }
 
      
    private func createTableView() {
        offlineView.tableView.dataSource = self
        offlineView.tableView.delegate = self
        offlineView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        offlineView.tableView.separatorStyle = .none
        offlineView.tableView.showsVerticalScrollIndicator = false
    }
    
    @objc  func startLoading() {
        self.updateByContentOffset()
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        offlineView.mmPlayerLayer.resume()
    }
    func updateByContentOffset() {
        if offlineView.mmPlayerLayer.isShrink {
            return
        }

        if let path = findCurrentPath(),
            self.presentedViewController == nil {
            self.updateCell(at: path)
        }
    }
    func findCurrentPath() -> IndexPath? {
        let p = CGPoint(x: offlineView.tableView.frame.width/2, y: offlineView.tableView.contentOffset.y + offlineView.tableView.frame.width/2)
        return offlineView.tableView.indexPathForRow(at: p)
    }

    func findCurrentCell(path: IndexPath) -> UITableViewCell {

        return offlineView.tableView.cellForRow(at: path)!
    }
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = offlineView.tableView.cellForRow(at: indexPath) as? PlayerViewCell, let playURL = cell.data?.streams?.first?.vodUrl {
            // this thumb use when transition start and your video dosent start
            offlineView.mmPlayerLayer.thumbImageView.image = cell.backgroundImage.image
            // set video where to play
            offlineView.mmPlayerLayer.playView = cell.backgroundImage
            let url = URL(string: playURL)////"http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4"
            //playURL
            offlineView.mmPlayerLayer.set(url: url)
        }
    }
    func destrtoyMMPlayerInstance() {
        self.offlineView.mmPlayerLayer.player?.pause()
        self.offlineView.mmPlayerLayer.playView = nil
    }

    //MARK: - Selectors

    func bindingChanellVOD(userId: String) {
        take = fitMeetStream.getBroadcastPrivateVOD(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {

                    self.brodcast = response.data!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.brodcast = self.brodcast.reversed()
                    self.offlineView.tableView.reloadData()
                }
           })
       }
    func bindingChanellVODNotAuth(userId: String) {
        take = fitMeetStream.getBroadcastPrivateVODNotAuth(userId: "\(userId)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {

                    self.brodcast = response.data!
                    let arrayUserId = self.brodcast.map{$0.userId!}
                    self.bindingUserMap(ids: arrayUserId)
                    self.brodcast = self.brodcast.reversed()
                    self.offlineView.tableView.reloadData()
                }
           })
       }
    func bindingUserMap(ids: [Int])  {
        take = fitMeetApi.getUserIdMap(ids: ids)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.usersd = response.data
                    self.offlineView.tableView.reloadData()
                }
          })
    }
    func followBroadcast(id: Int) {
       
        followBroad = fitMeetStream.followBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.categories != nil {
                    
                }
          })
    }
    func unFollowBroadcast(id: Int) {
        
        followBroad = fitMeetStream.unFollowBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               
         })
    }
    internal func vibrate() {
        if #available(iOS 10.0, *) {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

