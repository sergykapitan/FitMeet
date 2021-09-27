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
//import


extension HomeVC: UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].description
        cell.imageEye.isHidden = false
        cell.labelEye.isHidden = false
        
        
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard 
              let id = listBroadcast[indexPath.row].userId,
              let broadcastID = self.listBroadcast[indexPath.row].id
        else { return cell}

      //  self.arrayIdUser.append(id)
       // self.bindingUserMap(ids: arrayIdUser)
      //  self.bindingUser(id: id)
      //  let us = usersd.map { key,user in
      //      return user
      //  }
        
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
      
        
        if listBroadcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }
  
        
       
        self.url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        
        
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true
        
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        cell.setImageLogo(image: self.usersd[id]?.avatarPath ?? "https://logodix.com/logo/1070633.png")

        
        return cell
    }

    @objc func editButtonTapped(_ sender: UIButton) -> Void {
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
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        let id = self.listBroadcast[indexPath.row].userId
        let follow = self.listBroadcast[indexPath.row].followersCount
   
        
    
         
        guard let Url = url,let broadcastID = self.listBroadcast[indexPath.row].id,
              let channelId = self.listBroadcast[indexPath.row].channelIds else { return }
      
       
        
        self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
        let vc = PresentVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id = id
        vc.Url = Url
        vc.broadcast = self.listBroadcast[indexPath.row]
        print("Url === \(url)")
        vc.follow = "\(follow)"
        vc.broadId = broadcastID
        print("ID ===== \(id) \n URLLLLL ==== \(Url) \n Brpadcast ==== \(self.listBroadcast[indexPath.row]) \n Follow ====== \(follow)\n broadID === \(broadcastID)\n CHanelll ==== \(channelId)")
        navigationController?.pushViewController(vc, animated: true)

    }
}


extension HomeVC: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")



        var st = title
        st.remove(at: st.startIndex)
        
        for i in self.listCategory {
            if i.title == st {
                let detailVC = CategoryBroadcast()
                detailVC.categoryid = i.id
                detailVC.categoryTitle = i.title
                navigationController?.pushViewController(detailVC, animated: true)
                print("TITLe === \(i.title)\n ID == \(i.id) STSTSTSTST == \(st) ")
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
