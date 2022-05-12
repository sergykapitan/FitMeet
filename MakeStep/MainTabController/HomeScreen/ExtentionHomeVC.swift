//
//  ExtentionHomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit
import TagListView


extension HomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return listBroadcast.count
        }
      return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch  indexPath.section {
        case 0:
         let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHorizontalListTableViewCell", for: indexPath) as! HomeHorizontalListTableViewCell
            if let listUsers = listUsers {
                cell.setup(type: listUsers)
            }
         cell.delegate = self
         return cell
        
        case 1:
           
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
            
        guard !listBroadcast.isEmpty  else { return cell }

        cell.setImage(image:  listBroadcast[indexPath.row].resizedPreview?["preview_l"]?.png ?? "https://dev.makestep.com/api/v0/resizer?extension=jpeg&size=preview_m&path=%2Fqa-files%2Ffiles_95a4838f-6970-4728-afab-9d6a2345b943.jpeg" )
            
        cell.labelDescription.text = listBroadcast[indexPath.row].name
        

        guard
              let id = listBroadcast[indexPath.row].userId,
              let broadcastID = self.listBroadcast[indexPath.row].id
        else { return cell}
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        cell.titleLabel.text = self.usersd[id]?.fullName
         //   cell.titleLabel.text = self.channellsd[id]?.name
           
        
        self.ids.append(broadcastID)
        self.getMapWather(ids: [broadcastID])
        cell.overlay.labelEye.text = "\(self.watch)"
      
        let categorys = listBroadcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
            

        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.delegate = self
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row
        cell.buttonLike.isHidden = true
        
            
       guard let status = listBroadcast[indexPath.row].status  else { return cell}
        switch status {

        case .online:
                cell.overlayPlan.isHidden = true
                cell.overlayOffline.isHidden = true
                cell.overlay.isHidden = false
                cell.logoUserOnline.isHidden = false
                self.url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        case .offline:
                cell.overlayPlan.isHidden = true
                cell.overlay.isHidden = true
                cell.overlayOffline.isHidden = false
                cell.logoUserOnline.isHidden = true
                if let time = listBroadcast[indexPath.row].streams?.first?.vodLength {
                    cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
                } else {
                    cell.overlayOffline.labelLive.text = "00:00"
                }
                self.url = self.listBroadcast[indexPath.row].streams?.first?.vodUrl
        case .planned:
                cell.overlay.isHidden = true
                cell.overlayOffline.isHidden = true
                cell.overlayPlan.isHidden = false
                cell.overlayPlan.labelLive.text = listBroadcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
                cell.logoUserOnline.isHidden = true
        case .banned:
            break
        case .finished:
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false
            cell.logoUserOnline.isHidden = true
            if let time = listBroadcast[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                cell.overlayOffline.labelLive.text = "00:00"
            }
            self.url = self.listBroadcast[indexPath.row].streams?.first?.vodUrl
        case .wait_for_approve:
            break
        }

  
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
            
        cell.stackButton.tag = indexPath.row
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelectorMy(_:)))
        cell.stackButton.addGestureRecognizer(tap)
 
            if indexPath.row == listBroadcast.count - 2 {
                if self.itemCount > listBroadcast.count {
                    self.isLoadingList = true
                    self.loadMoreItemsForList()
                }
            }
        return cell
        
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "SimpleType", for: indexPath)
    }
    @objc func tapGestureSelectorMy(_ sender: UITapGestureRecognizer) {
        let tappedView = sender.view
        guard let viewTag = tappedView?.tag else { return }
        guard !listBroadcast.isEmpty else { return }
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        guard let id = listBroadcast[viewTag].userId else { return}
        vc.user = self.usersd[id]
        navigationController?.pushViewController(vc, animated: true)
        
    }

   @objc func moreButtonTapped(_ sender: UIButton) -> Void {
       guard token != nil else {
           let sign = SignInViewController()
           self.present(sign, animated: true, completion: nil)
           return
       }
        guard !listBroadcast.isEmpty else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: listBroadcast[sender.tag].id)
    }
}
extension HomeVC: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 315
        default:
            break
        }
       
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !self.listBroadcast.isEmpty,let broadcastID = self.listBroadcast[indexPath.row].id,
                let channelId = self.listBroadcast[indexPath.row].channelIds else { return }
        let vc = PlayerViewVC()
        vc.delegate = self

        guard let status = listBroadcast[indexPath.row].status  else { return }
        switch status {
            
        case .online:
            self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
            vc.broadcast = self.listBroadcast[indexPath.row]
            vc.id =  self.listBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.playerSlider.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.homeView.buttonPlayPause.isHidden = true
            vc.homeView.buttonSkipNext.isHidden = true
            vc.homeView.buttonSkipPrevious.isHidden = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .offline:
            guard let _ = listBroadcast[indexPath.row].streams?.first?.vodUrl else { return }
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
        case .planned:
            break
        case .banned:
            break
        case .finished:
            guard let _ = listBroadcast[indexPath.row].streams?.first?.vodUrl else { return }
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
        case .wait_for_approve:
            break
        }

    }
}
extension HomeVC: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        var st = title
        st.remove(at: st.startIndex)
        
        for i in self.listCategory {
            if i.title == st {
                let detailVC = CategoryBroadcast()
                detailVC.categoryid = i.id
                detailVC.categoryTitle = i.title
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }

        for ta in sender.tagViews {
        if ta.titleLabel?.text == title {
        ta.isSelected = !ta.isSelected
        }else{
        ta.isSelected = false
        }
      }
    }
}
extension HomeVC: HomeHorizontalListTableViewCellDelegate {
    func horizontalListItemTapped(index: Int, type: [User]) {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        vc.user = type[index]       
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension HomeVC: ReloadView {
    func reloadView() {
        if listBroadcast.isEmpty {
            self.getUsers()
        }
    }
}
extension HomeVC: OpenCoachDelegate {
    func coachTapped(userId: Int) {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.usersd[userId]
        navigationController?.pushViewController(vc, animated: true)
    }
}
