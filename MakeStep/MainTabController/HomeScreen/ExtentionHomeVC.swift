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
        if section == 1 {
            return listBroadcast.count
        } else if section == 0 {
           return  1
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
        cell.setImage(image:  listBroadcast[indexPath.row].resizedPreview?["preview_m"]?.jpeg ??  "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].description
        cell.imageEye.isHidden = false
        cell.labelEye.isHidden = false

        guard 
              let id = listBroadcast[indexPath.row].userId,
              let broadcastID = self.listBroadcast[indexPath.row].id
        else { return cell}
            
     

        
        self.ids.append(broadcastID)
        self.getMapWather(ids: [broadcastID])
        cell.labelEye.text = "\(self.watch)"
      
        let categorys = listBroadcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
            
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.delegate = self
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row
        cell.buttonLike.isHidden = true
      
       
  
        
        if listBroadcast[indexPath.row].status == "OFFLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.imageLive.setImageColor(color: .gray)
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            if let time = listBroadcast[indexPath.row].streams?.first?.vodLength {
            cell.labelLive.text =  " \(time.secondsToTime())"
            } else {
            cell.labelLive.text = ""
            }
            self.url = self.listBroadcast[indexPath.row].streams?.first?.vodUrl
        } else if listBroadcast[indexPath.row].status == "ONLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.labelLive.text = "Live"
            cell.imageEye.isHidden = false
            cell.labelEye.isHidden = false
            cell.logoUserOnline.isHidden = false
            self.url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        } else if listBroadcast[indexPath.row].status == "PLANNED" {
            cell.imageLive.image = #imageLiteral(resourceName: "clock")
            cell.labelLive.text = listBroadcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true

        }
        
        
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true
        
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
            
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        cell.titleLabel.text = self.usersd[id]?.fullName
        

        return cell
        
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "SimpleType", for: indexPath)
    }


    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        guard self.token != nil else {  return  }
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.followBroadcast(id: id)
        } else {
            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
        }
    }
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard self.token != nil else {  return  }
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.2
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        detailViewController.url = self.url        
        present(detailViewController, animated: true)

    }
    
}
extension HomeVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 330
        default:
            break
        }
       
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
   
            let id = self.listBroadcast[indexPath.row].userId

          guard let broadcastID = self.listBroadcast[indexPath.row].id,
                let channelId = self.listBroadcast[indexPath.row].channelIds else { return }

          self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
        //  let vc = ChannelCoach()
        //  vc.modalPresentationStyle = .fullScreen
        //  vc.user = self.usersd[id!]
        //  vc.broadcast = self.listBroadcast[indexPath.row]
        //  navigationController?.pushViewController(vc, animated: true)
        let vc = PlayerViewVC()

        if self.listBroadcast[indexPath.row] == nil {
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
            guard let stream = listBroadcast[indexPath.row].streams?.first else { return }
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
