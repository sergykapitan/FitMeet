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
        
        cell.buttonLike.isHidden = false
        cell.overlayPlan.isHidden = true
        cell.overlayOffline.isHidden = true
        cell.overlay.isHidden = true
        
      
        guard
              let id = sortListCategory[indexPath.row].userId,
              let broadcastID = self.sortListCategory[indexPath.row].id
              else { return cell}
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        cell.titleLabel.text = self.usersd[id]?.fullName

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

        
        
       
        self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        guard let status = sortListCategory[indexPath.row].status  else { return cell}
        switch status {
            
        case .online:
            cell.overlayPlan.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlay.isHidden = false
            cell.logoUserOnline.isHidden = false
            self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        case .offline:
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false

            if let time = sortListCategory[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                cell.overlayOffline.labelLive.text = "00:00"
            }
            self.url = self.sortListCategory[indexPath.row].streams?.first?.vodUrl
        case .planned:
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlayPlan.isHidden = false
            
            cell.overlayPlan.labelLive.text = sortListCategory[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.logoUserOnline.isHidden = true
        case .banned:
            break
        case .finished:
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false

            if let time = sortListCategory[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                cell.overlayOffline.labelLive.text = "00:00"
            }
            self.url = self.sortListCategory[indexPath.row].streams?.first?.vodUrl
        case .wait_for_approve:
            break
        }
  
        cell.stackButton.tag = indexPath.row
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelectorMy(_:)))
        cell.stackButton.addGestureRecognizer(tap)

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        return cell
    }
   
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return }
        guard let broadcastId = sortListCategory[sender.tag].id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)

    }
    @objc func tappedCoach(_ sender: UIButton) -> Void {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        guard let id = listBroadcast[sender.tag].userId else { return}
        vc.user = self.usersd[id]
        navigationController?.pushViewController(vc, animated: true)

    }
    @objc func tapGestureSelectorMy(_ sender: UITapGestureRecognizer) {
//        guard token != nil else {
//            let sign = SignInViewController()
//            self.present(sign, animated: true, completion: nil)
//            return }
        let tappedView = sender.view
        guard let viewTag = tappedView?.tag else { return }
        guard !listBroadcast.isEmpty else { return }
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        guard let id = listBroadcast[viewTag].userId else { return}
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

      guard let broadcastID = self.sortListCategory[indexPath.row].id,
            let channelId = self.sortListCategory[indexPath.row].channelIds else { return }

     
    let vc = PlayerViewVC()
        vc.delegate = self
        if self.sortListCategory[indexPath.row].id == nil {
        return
    }
        guard let status = self.sortListCategory[indexPath.row].status else { return}
        
        print("Statustape=\(status)")
        switch status {
            
        case .online:
            vc.broadcast = self.sortListCategory[indexPath.row]
            vc.id =  self.sortListCategory[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.playerSlider.isHidden = true
            self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .offline:
            guard let _ = sortListCategory[indexPath.row].streams?.first else { return }
            vc.broadcast = self.sortListCategory[indexPath.row]
            vc.id = self.sortListCategory[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .planned:
            break
        case .banned:
            break
        case .finished:
            guard let streams = sortListCategory[indexPath.row].streams else { return }
           
            if streams.isEmpty  { return }
                        guard let url = streams.first?.vodUrl else { return }
            guard let stream = sortListCategory[indexPath.row].streams?.first else { return }
            
            vc.broadcast = self.sortListCategory[indexPath.row]
            vc.id = self.sortListCategory[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.sortListCategory[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .wait_for_approve:
            break
        }
    }
}


extension CategoryBroadcast: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        for ta in sender.tagViews {
        if ta.titleLabel?.text == title {
        ta.isSelected = !ta.isSelected
        }else{
        ta.isSelected = false
        }
      }
    }
}
extension CategoryBroadcast: OpenCoachDelegate {
    func coachTapped(userId: Int) {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.usersd[userId]
        navigationController?.pushViewController(vc, animated: true)
    }
}
