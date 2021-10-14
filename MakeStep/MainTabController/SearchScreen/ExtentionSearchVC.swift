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
        let detailViewController = SendVC()
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
        

        if index == 0 {
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
            vc.follow = "\(follow)"
            vc.broadId = broadcastID
            navigationController?.pushViewController(vc, animated: true)
     
            
        } else if index == 1 {
            let user = listUsers[indexPath.row]
            guard let ids = user.id else { return }
            
            DispatchQueue(label: "getPhotos").sync {
                self.getBroadcast(userId: "\(ids)")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
//                   // Code you want to be delayed
//                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    guard let broadcastt = self.broadcast else { return }
                    let url = broadcastt.streams?.first?.hlsPlaylistUrl
                    let id = broadcastt.userId
                    let follow = broadcastt.followersCount
                          

                    guard let broadcastID = broadcastt.id,
                          let channelId = broadcastt.channelIds else { return }
                             
                              
                               
                               self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
                               let vc = PresentVC()
                               vc.modalPresentationStyle = .fullScreen
                               vc.id = id
                               vc.Url = url
                               vc.broadcast = self.listBroadcast[indexPath.row]
                               vc.follow = "\(follow)"
                               vc.broadId = broadcastID
                   self.navigationController?.pushViewController(vc, animated: true)

               }
            }

         
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
