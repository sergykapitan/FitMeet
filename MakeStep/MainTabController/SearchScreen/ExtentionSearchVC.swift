//
//  ExtentionSearchVC.swift
//  FitMeet
//
//  Created by novotorica on 11.06.2021.
//

import Foundation
import UIKit
import AVFoundation
import AVKit


extension SearchVC: UITableViewDataSource {
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        var indexCount = self.listBroadcast.count
       
        if index == 0 {
            indexCount = self.listBroadcast.count
            return self.listBroadcast.count
        } else if index == 1 {
            indexCount = self.listUsers.count
            return self.listUsers.count
        } else if index == 2 {
            indexCount = self.listCategory.count
            return self.listCategory.count
        }
  
        return indexCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCCell") as! SearchVCCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "SearchVCUserCell") as! SearchVCUserCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "SearchVCCategory") as! SearchVCCategory
        
        let defoultImage = "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg"

        if index == 0 {

            cell.labelDescription.text = listBroadcast[indexPath.row].name
            cell.titleLabel.text = listBroadcast[indexPath.row].categories?.first?.title
            cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? defoultImage )
            cell.buttonMore.tag = indexPath.row
            cell.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
            cell.buttonMore.isUserInteractionEnabled = true
            return cell

        }

        if index == 1 {
            cell2.setImage(image: listUsers[indexPath.row].avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png" )
            cell2.layoutIfNeeded()
            cell2.labelDescription.text = listUsers[indexPath.row].fullName
            cell2.titleLabel.text = "\(listUsers[indexPath.row].channelSubscribeCount!)" + "  Views"


            return cell2

        }
        if index == 2 {
            cell3.labelDescription.text = listCategory[indexPath.row].title
            return cell3
        }

        return cell
    }
    @objc func actionMore() {
        let detailViewController = SendCoach()
        actionSheetTransitionManager.height = 0.3
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        present(detailViewController, animated: true)

    }
}
extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeCell:CGFloat = 96
        
        if index == 0 {
            sizeCell =  96
        }
        if index == 1 {
            sizeCell = 77
        }
        if index == 2 {
            sizeCell = 40
        }
        return sizeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
       // var url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl

        if index == 0 {
//            //url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
//            let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
//            let id = self.listBroadcast[indexPath.row].userId
//            let follow = self.listBroadcast[indexPath.row].followersCount
//
//
//            guard let Url = url,let broadcastID = self.listBroadcast[indexPath.row].id,
//                  let channelId = self.listBroadcast[indexPath.row].channelIds else { return }
//
//            self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
//            let vc = PresentVC()
//            vc.modalPresentationStyle = .fullScreen
//            vc.id = id
//            vc.Url = Url
//            vc.broadcast = self.listBroadcast[indexPath.row]
//            vc.follow = "\(follow)"
//            vc.broadId = broadcastID
//
//            print("ID ===== \(id) \n URLLLLL ==== \(Url) \n Brpadcast ==== \(self.listBroadcast[indexPath.row]) \n Follow ====== \(follow)\n broadID === \(broadcastID)\n CHanelll ==== \(channelId)")
//            navigationController?.pushViewController(vc, animated: true)
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
     
            
        } else if index == 1 {
           // url = ""
            let user = listUsers[indexPath.row]
            let channelUs = ChanellVC()
            channelUs.user = user
            channelUs.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(channelUs, animated: true)
         
        } else if index == 2 {
            //url = ""
            let detailVC = CategoryBroadcast()
            detailVC.categoryid = listCategory[indexPath.row].id
            detailVC.categoryTitle = listCategory[indexPath.row].title
            navigationController?.pushViewController(detailVC, animated: true)
            return
        }

   }

}
