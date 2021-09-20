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


extension CategoryBroadcast: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortListCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryBroadcastCell", for: indexPath) as! CategoryBroadcastCell
//       // let text = viewModel.shared()[indexPath.row].searchText
//        cell.setImage(image: sortListCategory[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
//        cell.labelDescription.text = sortListCategory[indexPath.row].categories?.first?.description
//        cell.titleLabel.text = sortListCategory[indexPath.row].name
//        guard let category = sortListCategory[indexPath.row].categories?.first?.title else { return cell}
//        cell.labelCategory.text = category
//
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setImage(image: sortListCategory[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = sortListCategory[indexPath.row].description
        
        
        
        cell.titleLabel.text = sortListCategory[indexPath.row].name
        guard let category = sortListCategory[indexPath.row].categories?.first?.title,
              let category2 = sortListCategory[indexPath.row].categories?.last?.title,
              let id = sortListCategory[indexPath.row].userId,
              let broadcastID = self.sortListCategory[indexPath.row].id
              else { return cell}

        self.arrayIdUser.append(id)
       // self.bindingUserMap(ids: arrayIdUser)
        self.bindingUser(id: id)
        let us = usersd.map { key,user in
            return user
        }
        
        self.ids.append(broadcastID)
        self.getMapWather(ids: [broadcastID])
        cell.labelEye.text = "\(self.watch)"
 
        let categorys = sortListCategory[indexPath.row].categories
        let s = categorys!.map{$0.title!}.reduce("") { $0.title + " \u{0023}" + $1.title }  //
        cell.labelCategory.text = s

       
        
        if sortListCategory[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "iconlovered"), for: .normal)
        } else {
            cell.buttonLike.setImage(UIImage(named: "iconlove"), for: .normal)
        }
    
        print("SELF US ==== \(us.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.setImageLogo(image: self.user?.avatarPath ?? "https://logodix.com/logo/1070633.png")
        }
       
        self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        
        
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true
        
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
        
        
        return cell
    }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "iconlove") {
            sender.setImage(#imageLiteral(resourceName: "iconlovered"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.followBroadcast(id: id)
          //  binding()
           // self.homeView.tableView.reloadData()
        } else {
            sender.setImage(UIImage(named: "iconlove"), for: .normal)
           guard let id = listBroadcast[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
           // binding()
          //  self.homeView.tableView.reloadData()
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
extension CategoryBroadcast: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        let id = self.sortListCategory[indexPath.row].userId
        let follow = self.sortListCategory[indexPath.row].followersCount
   
        
    
         
        guard let Url = url,let broadcastID = self.sortListCategory[indexPath.row].id,
              let channelId = self.sortListCategory[indexPath.row].channelIds else { return }
      
       
        
        self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
        let vc = PresentVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id = id
        vc.Url = Url
        vc.broadcast = self.sortListCategory[indexPath.row]
        vc.follow = "\(follow)"
        vc.broadId = broadcastID
        navigationController?.pushViewController(vc, animated: true)

    }

}
