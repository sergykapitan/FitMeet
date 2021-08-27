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


extension HomeVC: UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].description
        
        
        
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard let category = listBroadcast[indexPath.row].categories?.first?.title,
              let category2 = listBroadcast[indexPath.row].categories?.last?.title,
              let id = listBroadcast[indexPath.row].userId
              else { return cell}
        
        print("IDDDDDDD===\(id)")
        var arrIds = [Int]()
        arrIds.append(id)
        
        print("KKKKKKKKK=====\(arrIds)")
        let categorys = listBroadcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}.reduce("") { $0.title + "\u{00B7} " + $1.title }  //
      
        cell.labelCategory.text = s

        cell.labelEye.text = " \(listBroadcast[indexPath.row].followersCount!)"        
        bindingUser(id: id)
       // self.bindingUserMap(ids: arrIds)
        
        if listBroadcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(UIImage(named: "Like-1"), for: .normal)
        }
        print("ARARARRARAARRARA= \(ar)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            
            cell.setImageLogo(image: self.user?.avatarPath ?? "https://logodix.com/logo/1070633.png")
          //  if  self.ar != nil {
           // guard let arrIds = self.ar else { return }
          //  cell.setImageLogo(image: self.ar[indexPath.row].avatarPath ?? "https://logodix.com/logo/1070633.png")
  
        }
       
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true
        
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
        
        
        return cell
    }

    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "Like-1") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.followBroadcast(id: id)
            binding()
            self.homeView.tableView.reloadData()
        } else {
            sender.setImage(UIImage(named: "Like-1"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
            binding()
            self.homeView.tableView.reloadData()
        }
    }
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        
        let detailViewController = SendVC()
 
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        
        present(detailViewController, animated: true)

    }
    
    
    
}
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        let id = self.listBroadcast[indexPath.row].userId
        let follow = self.listBroadcast[indexPath.row].followersCount
        print("ID BROAD === \(self.listBroadcast[indexPath.row].id)")
        print("ChanellId ==== \(self.listBroadcast[indexPath.row].channelIds)")
        
    
         
        guard let Url = url,let broadcastID = self.listBroadcast[indexPath.row].id,let channelId = self.listBroadcast[indexPath.row].channelIds else { return }
        
        self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
        let vc = PresentVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id = id
        vc.Url = Url
        vc.broadcast = self.listBroadcast[indexPath.row]
        vc.follow = "\(follow)"
        navigationController?.pushViewController(vc, animated: true)

    }
}


