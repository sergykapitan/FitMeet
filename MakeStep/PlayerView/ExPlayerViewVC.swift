//
//  ExPlayerViewVC.swift
//  MakeStep
//
//  Created by Sergey on 21.02.2022.
//

import Foundation
import UIKit
import AVKit


extension PlayerViewVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if brodcast.isEmpty {
            return 10
        }
        return  brodcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell
                 guard !brodcast.isEmpty  else { return cell }
        cell.hideAnimation()
        cell.setImage(image: brodcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? Constants.defoultImage)
        
       
        cell.labelDescription.text = brodcast[indexPath.row].name
       

        guard let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
        
       
        if let chanelId = brodcast[indexPath.row].channelIds?.last {
            cell.titleLabel.text = channellsd[chanelId]?.name
        }

        
        guard let categorys = brodcast[indexPath.row].categories else { return cell }
        let s = categorys.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row

        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
       


        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
       
        
        if indexPath.row == brodcast.count - 1 && !isLoadingList {
            if self.itemCount > brodcast.count {
            self.isLoadingList = true
            self.loadMoreItemsForList()
            } else if self.itemCount == brodcast.count {
                 token != nil ? bindingOff() : bindingOffNot()
            }
        }
  
       return cell
    }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
            self.followBroadcast(id: id)
        } else {
            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
        }
    }
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return
        }
            guard let broadcastId = self.broadcast?.id else { return }
            showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if brodcast.isEmpty { return }
        guard  let like = self.brodcast[indexPath.row].followersCount else { return }
        guard let status = brodcast[indexPath.row].status  else { return }
        self.videoEnd = false
        print(status)
     
        switch status {
          
        case .online:
            if homeView.buttonOpen.isSelected {
                actionTable()
            }
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = false
            homeView.imageLive.image = #imageLiteral(resourceName: "rec")
            homeView.labelLive.text = "Live ·"
            homeView.labelEye.text = "3"
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.playerSlider.isHidden = true
            homeView.labelLike.text = "\(like)"
            self.urlStream = brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
            playerViewController?.view.isHidden = false
            if playerViewController == nil {
                loadPlayer()
            }
            guard let user = brodcast[indexPath.row].userId else { return}
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            self.bindingUserNotApdate(id: user)
            guard let id = self.broadcast?.id else { return}
            self.incrementViewersCount(id: id)
        case .offline:
            if homeView.buttonOpen.isSelected {
                actionTable()
            }
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = true
            homeView.labelLive.alpha = 0
            homeView.imageLive.alpha = 0
            homeView.overlay.alpha = 0
            self.broadcast = brodcast[indexPath.row]
            self.urlStream = brodcast[indexPath.row].streams?.first?.vodUrl
            self.bindingLike()
            playerViewController?.view.isHidden = false
            if playerViewController == nil {
                loadPlayer()
            }
            guard let url = urlStream else { return }
            guard let videoURL = URL(string: url) else { return}
            self.homeView.playerSlider.setValue(0, animated: true)
            self.playerViewController?.player!.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
            setTimeVideo()
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.buttonPlayPause.isSelected = true
            self.actionPlayPause()
            guard let user = self.broadcast?.userId else { return}
            self.BoolTrack = false
            self.bindingUser(id: user)
            guard let id = self.broadcast?.id else { return}
            self.incrementViewersCount(id: id)
        case .planned:
            self.homeView.imageLogo.removeBlur()
            if homeView.buttonOpen.isSelected {
                actionTable()
            }
            self.urlStream = nil
            self.homeView.buttonChat.isHidden = true
            self.homeView.imageLogo.isHidden = false
            self.homeView.buttonstartStream.isHidden = false
            alphaButton()
            homeView.labelLive.alpha = 1
            homeView.imageLive.alpha = 1
            homeView.overlay.alpha = 1
            homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            self.broadcast = brodcast[indexPath.row]
            homeView.labelLive.text = self.brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            playerViewController?.player?.pause()
            playerViewController?.view.isHidden = true
            self.homeView.setImagePromo(image: brodcast[indexPath.row].previewPath ?? Constants.defoultImage)
            self.homeView.imageLogo.blurImage()
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.labelLike.text = "\(like)"
            guard let user = brodcast[indexPath.row].userId else { return}
            self.bindingUserNotApdate(id: user)
        case .banned:
            break
        case .finished:
            if homeView.buttonOpen.isSelected {
                actionTable()
            }
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.overlay.alpha = 0
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = true
            homeView.buttonChat.isHidden = true
            homeView.imageLive.isHidden = true
            homeView.labelLive.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.labelEye.isHidden = true
            homeView.playerSlider.isHidden = false
            self.broadcast = brodcast[indexPath.row]
            self.urlStream = brodcast[indexPath.row].streams?.first?.vodUrl
            self.bindingLike()
            playerViewController?.view.isHidden = false
            if playerViewController == nil {
                loadPlayer()
            }
            guard let url = urlStream else { return }
            guard let videoURL = URL(string: url) else { return}
            self.homeView.playerSlider.setValue(0, animated: true)
            self.playerViewController?.player!.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
            setTimeVideo()
            
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.buttonPlayPause.isSelected = true
            self.actionPlayPause()
            guard let user = self.broadcast?.userId else { return}
            self.BoolTrack = false
            self.bindingUser(id: user)
            guard let id = self.broadcast?.id else { return}
            self.incrementViewersCount(id: id)
        case .wait_for_approve:
            if homeView.buttonOpen.isSelected {
                actionTable()
            }
            self.homeView.buttonstartStream.isHidden = true
            self.urlStream = nil
            self.homeView.buttonChat.isHidden = true
            self.homeView.imageLogo.isHidden = false
            alphaButton()
            homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            homeView.labelLive.text = "Wait for"
            self.broadcast = brodcast[indexPath.row]
            playerViewController?.player?.pause()
            playerViewController?.view.isHidden = true
            self.homeView.setImagePromo(image: brodcast[indexPath.row].previewPath ?? Constants.defoultImage)
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.labelLike.text = "\(like)"
            guard let user = brodcast[indexPath.row].userId else { return}
            self.bindingUserNotApdate(id: user)
            guard let id = self.broadcast?.id else { return}
            self.incrementViewersCount(id: id)
        }

    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            let cell = tableView.cellForRow(at: indexPath)
            let selectedColor: UIColor
            let selectedView = UIView(frame: CGRect.zero)
            if tableView.isEditing == true {
                selectedColor = .clear
            } else {
                selectedColor = .lightGray
            }
            selectedView.backgroundColor = selectedColor
            cell?.multipleSelectionBackgroundView = selectedView
            return true
        }
  
}
extension PlayerViewVC: VeritiPurchase {
    func addPurchase() {        
        guard let userId = user?.id else { return }
        self.bindingChannel(userId: userId)
        
    }
}
extension PlayerViewVC {
    func switchType() {
        guard let stream = self.broadcast else { return }
        guard  let like = stream.followersCount else { return }
        guard let status = stream.status  else { return }
        self.videoEnd = false
      
        switch status {
          
        case .online:
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = false
            homeView.imageLive.image = #imageLiteral(resourceName: "rec")
            homeView.labelLive.text = "Live ·"
            homeView.labelEye.text = "3"
            homeView.imageEye.isHidden = false
            homeView.labelEye.isHidden = false
            homeView.playerSlider.isHidden = true
            homeView.labelLike.text = "\(like)"
            self.urlStream = stream.streams?.first?.hlsPlaylistUrl
            self.homeView.labelStreamInfo.text = stream.name
        case .offline:
            guard let _ = stream.streams?.first?.vodUrl else { return }
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = true
            homeView.labelLive.alpha = 0
            homeView.imageLive.alpha = 0
            homeView.overlay.alpha = 0
            self.broadcast = stream
            self.urlStream = stream.streams?.first?.vodUrl
            self.bindingLike()
            self.homeView.labelStreamInfo.text = stream.name
        case .planned:
            self.homeView.imageLogo.removeBlur()
            let selfId = UserDefaults.standard.string(forKey: Constants.userID)
            let usId = Int(selfId ?? "0")
            self.urlStream = nil
            self.homeView.buttonChat.isHidden = true
            self.homeView.imageLogo.isHidden = false
            alphaButton()
            if usId == broadcast?.userId {
                self.homeView.buttonstartStream.isHidden = false
            } else {
                self.homeView.buttonstartStream.isHidden = true
            }
            homeView.labelEye.alpha = 0
            homeView.imageEye.alpha = 0
            homeView.labelLive.alpha = 1
            homeView.imageLive.alpha = 1
            homeView.overlay.alpha = 1
            homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            self.broadcast = stream
            homeView.labelLive.text = stream.scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            playerViewController?.player?.pause()
            playerViewController?.view.isHidden = true
          
            self.homeView.setImagePromo(image: stream.previewPath ?? Constants.defoultImage)
            self.homeView.imageLogo.blurImage()
            self.homeView.labelStreamInfo.text = stream.name
            homeView.labelLike.text = "\(like)"
        case .banned:
            break
        case .finished:
            guard let _ = stream.streams?.first?.vodUrl else { return }
            self.homeView.buttonChat.isHidden = true
            self.homeView.buttonstartStream.isHidden = true
            self.homeView.overlay.alpha = 0
            self.homeView.imageLogo.isHidden = true
            self.homeView.buttonChat.isHidden = true
            
            homeView.labelLive.alpha = 0
            homeView.imageLive.alpha = 0
            homeView.overlay.alpha = 0
            
            self.broadcast = stream
            self.urlStream = stream.streams?.first?.vodUrl
            self.homeView.labelStreamInfo.text = self.broadcast?.name
        case .wait_for_approve:
            self.homeView.buttonstartStream.isHidden = true
            self.urlStream = nil
            self.homeView.buttonChat.isHidden = true
            self.homeView.imageLogo.isHidden = false
            homeView.labelEye.alpha = 0
            homeView.imageEye.alpha = 0
            homeView.labelLive.alpha = 1
            homeView.imageLive.alpha = 1
            homeView.overlay.alpha = 1
            homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            homeView.labelLive.text = "Wait for"
            self.broadcast = stream
            playerViewController?.player?.pause()
            playerViewController?.view.isHidden = true
            self.homeView.setImagePromo(image: stream.previewPath ?? Constants.defoultImage)
            self.homeView.labelStreamInfo.text = stream.name
            homeView.labelLike.text = "\(like)"
        }
    }
}
// MARK: - AVPictureInPictureDelegate

extension PlayerViewVC: AVPictureInPictureControllerDelegate{

  public func pictureInPictureControllerWillStartPictureInPicture( _ pictureInPictureController: AVPictureInPictureController) {
     
      activeCustomPlayerViewControllers.insert(self)
   
  }

  public func pictureInPictureControllerDidStartPictureInPicture( _ pictureInPictureController: AVPictureInPictureController ) {
    dismiss(animated: true, completion: nil)
  }

  public func pictureInPictureController( _ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error ) {
    activeCustomPlayerViewControllers.remove(self)
  }

  public func pictureInPictureControllerDidStopPictureInPicture( _ pictureInPictureController: AVPictureInPictureController ) {
    activeCustomPlayerViewControllers.remove(self)
  }

  public func pictureInPictureController( _ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void ) {
    delegatePicInPic?.playerViewController(self, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler: completionHandler)
  }
}
protocol CustomPlayerViewControllerDelegate: AnyObject {
  func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart( _ playerViewController: PlayerViewVC ) -> Bool

  func playerViewController( _ playerViewController: PlayerViewVC, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
  )
}

