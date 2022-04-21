//
//  ExtentionCategoryBroadcast.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit
import TagListView

extension CategoryBroadcast: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortListCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setImage(image: sortListCategory[indexPath.row].resizedPreview?["preview_l"]?.jpeg ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = sortListCategory[indexPath.row].name
        cell.buttonLike.isHidden = true
        
        
      
        guard
              let id = sortListCategory[indexPath.row].userId,
              let broadcastID = self.sortListCategory[indexPath.row].id
              else { return cell}

        self.ids.append(broadcastID)
        self.getMapWather(ids: [broadcastID])
        cell.overlay.labelEye.text = "\(self.watch)"
        
     
 
        let categorys = sortListCategory[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.delegate = self
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row

        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        cell.titleLabel.text = self.usersd[id]?.fullName
        
       
        self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        
        if listBroadcast[indexPath.row].status == "OFFLINE" {
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false

            if let time = listBroadcast[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                cell.overlayOffline.labelLive.text = "00:00"
            }
            self.url = self.listBroadcast[indexPath.row].streams?.first?.vodUrl
            
        } else if listBroadcast[indexPath.row].status == "ONLINE" {
            cell.overlayPlan.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlay.isHidden = false
            
            cell.logoUserOnline.isHidden = false
            self.url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        } else if listBroadcast[indexPath.row].status == "PLANNED" {
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlayPlan.isHidden = false
            
            cell.overlayPlan.labelLive.text = listBroadcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.logoUserOnline.isHidden = true

        }
            
        cell.buttonLogo.tag = indexPath.row
        cell.buttonLogo.addTarget(self, action: #selector(tappedCoach), for: .touchUpInside)
        cell.buttonLogo.isUserInteractionEnabled = true

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
        
        
        return cell
    }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = sortListCategory[sender.tag].id else { return }
            self.followBroadcast(id: id)
        } else {
            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
           guard let id = sortListCategory[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
        }
    }
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil,let broadcastId = sortListCategory[sender.tag].id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)

    }
    @objc func tappedCoach(_ sender: UIButton) -> Void {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        guard let id = listBroadcast[sender.tag].userId else { return}
        vc.user = self.usersd[id]
        navigationController?.pushViewController(vc, animated: true)

    }    
}
extension CategoryBroadcast: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

      guard let broadcastID = self.listBroadcast[indexPath.row].id,
            let channelId = self.listBroadcast[indexPath.row].channelIds else { return }

      self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
    let vc = PlayerViewVC()

        if self.listBroadcast[indexPath.row].id == nil {
        return
    }
    if self.listBroadcast[indexPath.row].status == "ONLINE" {
        vc.broadcast = self.listBroadcast[indexPath.row]
        vc.id =  self.listBroadcast[indexPath.row].userId
        vc.homeView.buttonChat.isHidden = false
        vc.homeView.playerSlider.isHidden = true
        vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    } else if  self.listBroadcast[indexPath.row].status == "OFFLINE" {
        guard let _ = listBroadcast[indexPath.row].streams?.first else { return }
        vc.broadcast = self.listBroadcast[indexPath.row]
        vc.id = self.listBroadcast[indexPath.row].userId
        vc.homeView.buttonChat.isHidden = true
        vc.homeView.overlay.isHidden = true
        vc.homeView.imageLive.isHidden = true
        vc.homeView.labelLive.isHidden = true
        vc.homeView.imageEye.isHidden = true
        vc.homeView.labelEye.isHidden = true
        vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    } else if  self.listBroadcast[indexPath.row].status == "PLANNED" {
        print("PLANNED")
        return
    } else if  self.listBroadcast[indexPath.row].status == "WAIT_FOR_APPROVE" {
        print("WAIT_FOR_APPROVE")
        return
    } else if  self.listBroadcast[indexPath.row].status == "FINISHED" {
        print("FINISHED")
        return
    }
}

    }


extension CategoryBroadcast: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")

        for ta in sender.tagViews {
        if ta.titleLabel?.text == title {
        ta.isSelected = !ta.isSelected
        }else{
        ta.isSelected = false
        }
      }
    }
}
