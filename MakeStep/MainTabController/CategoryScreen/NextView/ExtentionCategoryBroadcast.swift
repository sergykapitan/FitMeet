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
        cell.labelDescription.text = sortListCategory[indexPath.row].description
        
        
        
      
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

       
        
        if sortListCategory[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }
    
      
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
        
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true
        
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
        
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.2
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        detailViewController.url = self.url
        present(detailViewController, animated: true)

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
        let id = self.sortListCategory[indexPath.row].userId
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.usersd[id!]
        navigationController?.pushViewController(vc, animated: true)

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
