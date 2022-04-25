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
        return  brodcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell

        if brodcast[indexPath.row].previewPath == "/path/to/file.jpg" {
            cell.setImage(image:"https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        } else {
            cell.setImage(image: brodcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        }
       
        cell.labelDescription.text = brodcast[indexPath.row].name
       

        guard let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
        
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        cell.titleLabel.text = self.usersd[id]?.fullName

        guard let status = brodcast[indexPath.row].status else { return cell}
        switch status {
            
        case .online:
            cell.buttonstartStream.isHidden = true
        case .offline:
            cell.buttonstartStream.isHidden = true
        case .planned:
            cell.buttonstartStream.isHidden = false
        case .banned:
            break
        case .finished:
            break
        case .wait_for_approve:
            break
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
        guard  let like = self.brodcast[indexPath.row].followersCount else { return }
        guard let status = brodcast[indexPath.row].status  else { return }
        self.videoEnd = false
        print(status)
        switch status {
          
        case .online:
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
            guard let user = brodcast[indexPath.row].userId else { return}
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            self.bindingUserNotApdate(id: user)
        case .offline:
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
        case .planned:
            self.urlStream = nil
            self.homeView.buttonChat.isHidden = true
            self.homeView.imageLogo.isHidden = false
            homeView.labelEye.isHidden = true
            homeView.imageEye.isHidden = true
            homeView.playerSlider.isHidden = false
            homeView.labelEye.isHidden = true
            homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            homeView.labelLive.text = self.brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            playerViewController?.player?.pause()
            playerViewController!.view.removeFromSuperview()
            self.homeView.setImagePromo(image: brodcast[indexPath.row].previewPath!)
            self.homeView.labelStreamInfo.text = self.broadcast?.name
            homeView.labelLike.text = "\(like)"
            guard let user = brodcast[indexPath.row].userId else { return}
            self.bindingUserNotApdate(id: user)
        case .banned:
            break
        case .finished:
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
        case .wait_for_approve:
           self.homeView.imageLogo.isHidden = true
           self.homeView.buttonChat.isHidden = true
           homeView.labelEye.isHidden = true
           homeView.imageEye.isHidden = true
           homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
           homeView.labelLive.text = "Wait for"
           homeView.playerSlider.isHidden = false
           homeView.labelEye.isHidden = true
           self.urlStream = brodcast[indexPath.row].streams?.first?.vodUrl
           self.homeView.labelStreamInfo.text = self.broadcast?.name
           homeView.labelLike.text = "\(like)"
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
